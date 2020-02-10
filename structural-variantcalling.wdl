version 1.0

import "tasks/common.wdl" as common
import "tasks/delly.wdl" as delly
import "tasks/manta.wdl" as manta
import "tasks/picard.wdl" as picard
import "tasks/bcftools.wdl" as bcftools
import "tasks/survivor.wdl" as survivor
import "tasks/clever.wdl" as clever
import "tasks/bwa.wdl" as bwa
import "tasks/samtools.wdl" as samtools

workflow SVcalling {
    input {
        File bamFile
        File bamIndex
        File referenceFasta
        File referenceFastaFai
        File referenceFastaDict
        File dockerImagesFile
        BwaIndex bwaIndex
        String sample
        String outputDir = "."
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
            outputPathBam = outputDir + '/structural-variants/filteredBam/' + sample + ".filtered.bam",
            outputPathBamIndex = outputDir + '/structural-variants/filteredBam/' + sample + ".filtered.bai"
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
            sample = sample,
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
