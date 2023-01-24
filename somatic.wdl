version 1.0

# MIT License
#
# Copyright (c) 2023 Leiden University Medical Center
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.


import "tasks/bwa.wdl" as bwa
import "tasks/common.wdl" as common
import "tasks/delly.wdl" as delly
import "tasks/gridss.wsl" as gridss
import "tasks/manta.wdl" as manta


workflow SomaticSvCalling {
    input {
        Array[String] normalIds
        Array[File] normalBams
        Array[File] normalBamIndexes
        Array[String] tumorIds
        Array[File] tumorBams
        Array[File] tumorBamIndexes
        Array[Pair[String, String]] pairs # tumor, normal
        File referenceFasta
        File referenceFastaFai
        BwaIndex bwaIndex
        String outputDir = "."
        File? gridssPonBed
        File? gridssPonBedpe
    }

    scatter (pair in pairs) {
        String tumorName = pair.left
        String normalName = pair.right

        call common.GetSamplePositionInArray as tumorPosition {
            input:
                sampleIds = tumorIds,
                sample = tumorName
        }

        File tumorBam = tumorBams[tumorPosition.position]
        File tumorBamIndex = tumorBamIndexes[tumorPosition.position]

        call common.GetSamplePositionInArray as normalPosition {
            input:
                sampleIds = normalIds,
                sample = normalName
        }

        File normalBam = normalBams[normalPosition.position]
        File normalBamIndex = normalBam[normalPosition.position]

        # Delly
        call delly.CallSV as dellyCall {
            input:
                bamFile = [tumorBam, normalBam],
                bamIndex = [tumorBamIndex, normalBamIndex],
                referenceFasta = referenceFasta,
                referenceFastaFai = referenceFastaFai,
                outputPath = "~{outputDir}/delly/~{tumorName}_~{normalName}.delly.bcf"
        }

        call delly.Filter as dellySomaticFilter {
            input:
                dellyBcf = dellyCall.dellyBcf,
                normalSamples = [normalName],
                tumorSamples = [tumorName],
                outputPath = "~{outputDir}/delly/~{tumorName}_~{normalName}.pre.delly.bcf"
        }

        #FIXME This may be parralellized per normal if it's too slow like this
        call delly.CallSV as dellyGenotypeNormals {
            input:
                bamFile = flatten([[tumorBam], normalBams]),
                bamIndex = flatten([[tumorBamIndex], normalBamIndexes]),
                referenceFasta = referenceFasta,
                referenceFastaFai = referenceFastaFai,
                genotypeBcf = dellySomaticFilter.filterBcf,
                outputPath = "~{outputDir}/delly/~{tumorName}.geno.delly.bcf"
        }

        call delly.Filter as dellyPonFilter {
            input:
                dellyBcf = dellyGenotypeNormals.dellyBcf,
                normalSamples = normalIds,
                tumorSamples = [tumorName],
                outputPath = "~{outputDir}/delly/~{tumorName}.somatic.delly.bcf"
        }

        # Manta
        call manta.Somatic as mantaSomatic {
            input:
                tumorBam = tumorBam,
                tumorBamIndex = tumorBamIndex,
                referenceFasta = referenceFasta,
                referenceFastaFai = referenceFastaFai,
                runDir = "~{outputDir}/manta",
                normalBam = normalBam,
                normalBamIndex = normalBamIndex
        }
    }

    # GRIDSS
    scatter (normalNameGridss in normalIds) {
        call common.GetSamplePositionInArray as normalPositionGridss {
            input:
                sampleIds = normalIds,
                sample = normalNameGridss
        }
        File normalBamGridss = normalBams[normalPositionGridss.position]
        File normalBamIndexGridss = normalBamIndexes[normalPositionGridss.position]
        
        # Collect all tumors for this normal
        scatter (pair in pairs) {
            if (pair.right == normalNameGridss) {
                String tumorNameGridss = pair.left

                call common.GetSamplePositionInArray as tumorPositionGridss {
                    input:
                        sampleIds = tumorIds,
                        sample = tumorNameGridss
                }

                File tumorBamGridss = tumorBam[tumorPositionGridss.position]
                File tumorBamIndexGridss = tumorBamIndexes[tumorPositionGridss.position]
            }
        }
        Array[String] tumorNamesGridss = select_all(tumorNameGridss)
        Array[File] tumorBamsGridss = select_all(tumorBamGridss)
        Array[File] tumorBamIndexesGridss = select_all(tumorBamIndexGridss)

        # Call GRIDSS on the grouped samples
        call gridss.GRIDSS as groupedGridss {
            input:
                tumorBam = tumorBamsGridss,
                tumorBai = tumorBamIndexesGridss,
                tumorLabel = tumorNamesGridss,
                reference = bwaIndex,
                outputPrefix = "~{outputdir}/~{normalNameGridss}_group",
                normalBam = normalBamGridss,
                normalBai = normalBamIndexGridss,
                normalLabel = normalNameGridss
        }
    }

    # generate PON
    if (! defined(gridssPonBed) || ! defined(gridssPonBedpe)) {
        call gridss.GeneratePonBedpe as generateGridssPon {
            input:
                vcfFiles = groupedGridss.vcf,
                vcfIndexes = groupedGridss.vcfIndex,
                referenceFasta = referenceFasta
        }

        call gridss.FilterPon as filterGridssPon {
            input:
                ponBed = generateGridssPon.bed,
                ponBedpe = generateGridssPon.bedpe
        }
    }

    # somatic filter
    call gridss.SomaticFilter as gridssSomaticFilter {
        input:
            ponBed = select_first([filterGridssPon.bed, gridssPonBed]),
            ponBedpe = select_first([filterGridssPon.bedpe, gridssPonBedpe]),
            vcfFile = groupedGridss.vcf,
            vcfIndex = groupedGridss.vcfIndex
    }
    
    #TODO gridss SV typing?
    #TODO split by tumor sample?

    output {
        Array[File] dellySvBcfs = dellyPonFilter.filterBcf
        Array[File] mantaSvVcfs = mantaSomatic.tumorSVVcf
        Array[File] mantaSvVcfIndexes = mantaSomatic.tumorSVVcf
        Array[File] gridssSvVcfs = gridssSomaticFilter.highConfidenceVcf
        Array[File] gridssSvVcfIndexes = gridssSomaticFilter.highConfidenceVcfIndex
        Array[File] fullGridssSvs = gridssSomaticFilter.fullOutput
        File? generatedGridssPonBed = filterGridssPon.bed
        File? generatedGridssPonBedpe = filterGridssPon.bedpe
    }
}
