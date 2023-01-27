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
import "tasks/gridss.wdl" as gridss
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
        String selectedTumorName = pair.left
        String selectedNormalName = pair.right

        call common.GetSamplePositionInArray as tumorPosition {
            input:
                sampleIds = tumorIds,
                sample = selectedTumorName
        }

        File selectedTumorBam = tumorBams[tumorPosition.position]
        File selectedTumorBamIndex = tumorBamIndexes[tumorPosition.position]

        call common.GetSamplePositionInArray as normalPosition {
            input:
                sampleIds = normalIds,
                sample = selectedNormalName
        }

        File selectedNormalBam = normalBams[normalPosition.position]
        File selectedNormalBamIndex = normalBamIndexes[normalPosition.position]

        # Delly
        call delly.CallSV as dellyCall {
            input:
                bamFile = [selectedTumorBam, selectedNormalBam],
                bamIndex = [selectedTumorBamIndex, selectedNormalBamIndex],
                referenceFasta = referenceFasta,
                referenceFastaFai = referenceFastaFai,
                outputPath = "~{outputDir}/~{selectedTumorName}/delly/~{selectedTumorName}_~{selectedNormalName}.delly.bcf"
        }

        call delly.SomaticFilter as dellySomaticFilter {
            input:
                dellyBcf = dellyCall.dellyBcf,
                dellyBcfIndex = dellyCall.dellyBcfIndex,
                normalSamples = [selectedNormalName],
                tumorSamples = [selectedTumorName],
                outputPath = "~{outputDir}/~{selectedTumorName}/delly/~{selectedTumorName}_~{selectedNormalName}.pre.delly.bcf"
        }

        #FIXME This may be parralellized per normal if it's too slow like this
        call delly.CallSV as dellyGenotypeNormals {
            input:
                bamFile = flatten([[selectedTumorBam], normalBams]),
                bamIndex = flatten([[selectedTumorBamIndex], normalBamIndexes]),
                referenceFasta = referenceFasta,
                referenceFastaFai = referenceFastaFai,
                genotypeBcf = dellySomaticFilter.filterBcf,
                genotypeBcfIndex = dellySomaticFilter.filterBcfIndex,
                outputPath = "~{outputDir}/~{selectedTumorName}/delly/~{selectedTumorName}.geno.delly.bcf"
        }

        call delly.SomaticFilter as dellyPonFilter {
            input:
                dellyBcf = dellyGenotypeNormals.dellyBcf,
                dellyBcfIndex = dellyGenotypeNormals.dellyBcfIndex,
                normalSamples = normalIds,
                tumorSamples = [selectedTumorName],
                outputPath = "~{outputDir}/~{selectedTumorName}/delly/~{selectedTumorName}.somatic.delly.bcf"
        }

        # Manta
        call manta.Somatic as mantaSomatic {
            input:
                tumorBam = selectedTumorBam,
                tumorBamIndex = selectedTumorBamIndex,
                referenceFasta = referenceFasta,
                referenceFastaFai = referenceFastaFai,
                runDir = "~{outputDir}/~{selectedTumorName}/manta",
                normalBam = selectedNormalBam,
                normalBamIndex = selectedNormalBamIndex
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

                File tumorBamGridss = tumorBams[tumorPositionGridss.position]
                File tumorBamIndexGridss = tumorBamIndexes[tumorPositionGridss.position]
            }
        }
        Array[String] groupedTumorNamesGridss = select_all(tumorNameGridss)
        Array[File] groupedTumorBamsGridss = select_all(tumorBamGridss)
        Array[File] groupedTumorBamIndexesGridss = select_all(tumorBamIndexGridss)

        # Call GRIDSS on the grouped samples
        call gridss.GRIDSS as groupedGridss {
            input:
                tumorBam = groupedTumorBamsGridss,
                tumorBai = groupedTumorBamIndexesGridss,
                tumorLabel = groupedTumorNamesGridss,
                reference = bwaIndex,
                outputPrefix = "~{outputDir}/gridss/~{normalNameGridss}/group",
                normalBam = normalBamGridss,
                normalBai = normalBamIndexGridss,
                normalLabel = normalNameGridss
        }

        GroupedGridssVcf groupedVcfs = object {
            vcf: groupedGridss.vcf,
            index: groupedGridss.vcfIndex,
            normal: normalNameGridss,
            tumors: groupedTumorNamesGridss
        }
    }

    # generate GRIDSS PON
    if (! defined(gridssPonBed) || ! defined(gridssPonBedpe)) {
        call gridss.GeneratePonBedpe as generateGridssPon {
            input:
                vcfFiles = groupedGridss.vcf,
                vcfIndexes = groupedGridss.vcfIndex,
                referenceFasta = referenceFasta,
                outputDir = "~{outputDir}/gridss/raw_PON"
        }

        call gridss.FilterPon as filterGridssPon {
            input:
                ponBed = generateGridssPon.bed,
                ponBedpe = generateGridssPon.bedpe,
                outputDir = "~{outputDir}/gridss/filtered_PON"
        }
    }

    # somatic filter
    scatter (groupedVcf in groupedVcfs) {
        call gridss.SomaticFilter as gridssSomaticFilter {
            input:
                ponBed = select_first([gridssPonBed, filterGridssPon.bed]),
                ponBedpe = select_first([gridssPonBedpe, filterGridssPon.bedpe]),
                vcfFile = groupedVcf.vcf,
                vcfIndex = groupedVcf.index,
                outputPath = "~{outputDir}/gridss/~{groupedVcf.normal}/high_confidence_somatic.vcf.gz",
                fullOutputPath = "~{outputDir}/gridss/~{groupedVcf.normal}/high_and_low_confidence_somatic.vcf.gz"
        }

        #TODO split by tumor sample?
        #TODO gridss SV typing?
    }

    output {
        Array[File] dellySvBcfs = dellyPonFilter.filterBcf
        Array[File] mantaSvVcfs = mantaSomatic.tumorSVVcf
        Array[File] mantaSvVcfIndexes = mantaSomatic.tumorSVVcfIndex
        Array[File] gridssSvVcfs = gridssSomaticFilter.highConfidenceVcf
        Array[File] gridssSvVcfIndexes = gridssSomaticFilter.highConfidenceVcfIndex
        Array[File] fullGridssSvs = gridssSomaticFilter.fullVcf
        Array[File] fullGridssSvsIndex = gridssSomaticFilter.fullVcfIndex
        File? generatedGridssPonBed = filterGridssPon.bed
        File? generatedGridssPonBedpe = filterGridssPon.bedpe
    }

    parameter_meta {
        normalIds: {description: "The IDs of the normal samples in the same order as the BAM files.", category: "required"}
        normalBams: {description: "The BAM files for the normal samples in the same order as IDs.", category: "required"}
        normalBamIndexes: {description: "The indexes for the normal BAM files in the same order as the BAM files.", category: "required"}
        tumorIds: {description: "The IDs of the tumor samples in the same order as the BAM files.", category: "required"}
        tumorBams: {description: "The BAM files for the tumor samples in the same order as IDs.", category: "required"}
        tumorBamIndexes: {description: "The indexes for the tumor BAM files in the same order as the BAM files.", category: "required"}
        pairs: {description: "The tumor-normal pairs. The left element is the ID for the tumor and the right element is the ID for the associated normal.", category: "required"}
        referenceFasta: {description: "The FASTA file for the reference genome.", category: "required"}
        referenceFastaFai: {description: "The index for the reference genomes FASTA file.", category: "required"}
        bwaIndex: {description: "The BWA index for the reference genome.", category: "required"}
        outputDir: {description: "The directory the output should be written to.", category: "common"}
        gridssPonBed: {description: "A premade PON single breakend BED file for GRIDSS.", category: "common"}
        gridssPonBedpe: {description: "A premade PON breakpoint BEDPE file for GRIDSS.", category: "common"}
    }
}


struct GroupedGridssVcf {
    File vcf
    File index
    String normal
    Array[String] tumors
}