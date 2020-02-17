version 1.0

# MIT License
#
# Copyright (c) 2018 Leiden University Medical Center
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

import "tasks/bcftools.wdl" as bcftools
import "tasks/bwa.wdl" as bwa
import "tasks/clever.wdl" as clever
import "tasks/common.wdl" as common
import "tasks/delly.wdl" as delly
import "tasks/manta.wdl" as manta
import "tasks/picard.wdl" as picard
import "tasks/samtools.wdl" as samtools
import "tasks/survivor.wdl" as survivor

workflow SVcalling {
    input {
        File bamFile
        File bamIndex
        File referenceFasta
        File referenceFastaFai
        File referenceFastaDict
        BwaIndex bwaIndex
        String sample
        String outputDir = "."
        File dockerImagesFile
    }

    # Parse docker Tags configuration and sample sheet
    call common.YamlToJson as ConvertDockerTagsFile {
        input:
            yaml = dockerImagesFile,
            outputJson = outputDir + "/dockerImages.json"
    }

    Map[String, String] dockerImages = read_json(ConvertDockerTagsFile.json)
     
    call delly.CallSV as delly {
        input:
            dockerImage = dockerImages["delly"],
            bamFile = bamFile,
            bamIndex = bamIndex,
            referenceFasta = referenceFasta,
            referenceFastaFai = referenceFastaFai,
            outputPath = outputDir + '/structural-variants/delly/' + sample + ".delly.bcf"
    }   

    call bcftools.Bcf2Vcf as delly2vcf {
        input:
            dockerImage = dockerImages["bcftools"],
            bcf = delly.dellyBcf,
            outputPath = outputDir + '/structural-variants/delly/' + sample + ".delly.vcf"
    } 

    call clever.Prediction as clever {
        input:
            dockerImage = dockerImages["clever"],
            bamFile = bamFile,
            bamIndex = bamIndex,
            bwaIndex = bwaIndex,
            outputPath = outputDir + '/structural-variants/clever/'
    } 
    
    call samtools.FilterShortReadsBam {
        input:
            dockerImage = dockerImages["samtools"],
            bamFile = bamFile,
            outputPathBam = outputDir + '/structural-variants/filteredBam/' + sample + ".filtered.bam"
    }

    call clever.Mateclever as mateclever {
        input:
            dockerImage = dockerImages["clever"],
            fiteredBam = FilterShortReadsBam.filteredBam,
            indexedFiteredBam = FilterShortReadsBam.filteredBamIndex,
            bwaIndex = bwaIndex,
            predictions = clever.predictions,
            outputPath = outputDir + '/structural-variants/mateclever/'
    }

   call manta.Germline as manta {
       input:
            dockerImage = dockerImages["manta"],
            bamFile = bamFile,
            bamIndex = bamIndex,
            referenceFasta = referenceFasta,
            referenceFastaFai = referenceFastaFai,
            runDir = outputDir + '/structural-variants/manta/'
   }

   Array[Pair[File,String]] vcfAndCaller = [(delly2vcf.outputVcf, "delly"),(manta.mantaVCF,"manta"), 
       (mateclever.matecleverVcf, "clever")]

   scatter (pair in vcfAndCaller){
       call picard.RenameSample as renameSample {
           input:
                dockerImage = dockerImages["picard"],
                inputVcf = pair.left,
                outputPath = outputDir + '/structural-variants/modifiedVCFs/' + sample + "." + pair.right + '.vcf',
                newSampleName = sample + "." + pair.right 
       }
   }
   
   call survivor.Merge as survivor {
       input:
            dockerImage = dockerImages["survivor"],
            filePaths = renameSample.renamedVcf,
            outputPath = outputDir + '/structural-variants/survivor/' + sample + '.merged.vcf'
   }
   
   output {
        File cleverPredictions = clever.predictions
        File cleverVcf = mateclever.matecleverVcf
        File mantaVcf = manta.mantaVCF
        File dellyBcf = delly.dellyBcf
        File dellyVcf = delly2vcf.outputVcf
        File survivorVcf = survivor.mergedVcf
        Array[File] renamedVcfs = renameSample.renamedVcf 
   }

   parameter_meta {
        outputDir: {description: "The directory the output should be written to.", category: "common"}
        referenceFasta: { description: "The reference fasta file", category: "required" }
        referenceFastaFai: { description: "Fasta index (.fai) file of the reference", category: "required" }
        referenceFastaDict: { description: "Sequence dictionary (.dict) file of the reference", category: "required" }
        bamFile: {description: "sorted BAM file", category: "required"}
        bamIndex: {description: "BAM index(.bai) file", category: "required"}
        bwaIndex: {description: "Struct containing the BWA reference files", category: "required"}
        sample: {description: "The name of the sample", category: "required"}
        memory: {description: "The memory required to run the programs", category: "common"}
        memoryGb: {description: "The memory required to run the manta", category: "common"}
        cores: {description: "The the number of cores required to run a program", category: "common"}
        threads: {description: "The the number of threads required to run a program", category: "common"}
        javaXmx: {description: "The max. memory allocated for JAVA", category: "common"}
        dockerImagesFile: {description: "A YAML file describing the docker image used for the tasks. The dockerImages.yml provided with the pipeline is recommended.",
                           category: "advanced"}
                           
        minSize: {description: "The mimimum size of SV to be merged", category: "required"}
        distanceBySvSize: {description: "A boolean to predict the pairwise distance between the SVs based on their size", category: "required"}
        strandType: {description: "A boolean to include strand type of an SV to be merged", category: "required"}
        svType: {description: "A boolean to include the type SV to be merged", category: "required"}
        suppVecs: {description: "The minimum number of SV callers to support the merging", category: "required"}
        breakpointDistance: {description: "The distance between pairwise breakpoints between SVs", category: "required"}
   }
}
