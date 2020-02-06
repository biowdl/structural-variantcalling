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
        BwaIndex bwaIndex
        String sample
        String outputDir = "."
    }
     
    call delly.CallSV as delly {
        input:
            bamFile = bamFile,
            bamIndex = bamIndex,
            referenceFasta = referenceFasta,
            referenceFastaFai = referenceFastaFai,
            outputPath = outputDir + 'structural-variants/delly/' + sample + ".delly.bcf"
    }   

    call bcftools.Bcf2Vcf as delly2vcf {
        input:
            bcf = delly.dellyBcf,
            outputPath = outputDir + 'structural-variants/delly/' + sample + ".delly.vcf"
    } 

    call clever.Prediction as clever {
        input:
            bamFile = bamFile,
            bamIndex = bamIndex,
            bwaIndex = bwaIndex,
            outputPath = outputDir + 'structural-variants/clever/'
    } 
    
    call samtools.FilterShortReadsBam {
        input:
            bamFile = bamFile,
            outputPathBam = outputDir + 'structural-variants/filteredBam/' + sample + ".filtered.bam"
    }

    call clever.Mateclever as mateclever {
        input:
            fiteredBam = FilterShortReadsBam.filteredBam,
            indexedFiteredBam = FilterShortReadsBam.filteredBamIndex,
            bwaIndex = bwaIndex,
            predictions = clever.predictions,
            outputPath = outputDir + 'structural-variants/mateclever/'
    }

   call manta.Germline as manta {
       input:
           bamFile = bamFile,
           bamIndex = bamIndex,
           referenceFasta = referenceFasta,
           referenceFastaFai = referenceFastaFai,
           runDir = outputDir + 'structural-variants/manta/'
   }

   Array[Pair[File,String]] vcfAndCaller = [(delly2vcf.OutputVcf, "delly"),(manta.mantaVCF,"manta"), 
       (mateclever.matecleverVcf, "clever")]

   scatter (pair in vcfAndCaller){
       call picard.RenameSample as renameSample {
           input:
               inputVcf = pair.left,
               outputPath = outputDir + 'structural-variants/modifiedVCFs/' + sample + "." + pair.right + '.vcf',
               newSampleName = sample + "." + pair.right 
       }
   }
   
   call survivor.Merge as survivor {
       input:
           filePaths = renameSample.renamedVcf,
           sample = sample,
           outputPath = outputDir + 'structural-variants/survivor/' + sample + '.merged.vcf'
   }
   
   output {
       File cleverPredictions = clever.predictions
       File cleverVcf = mateclever.matecleverVcf
       File mantaVcf = manta.mantaVCF
       File dellyBcf = delly.dellyBcf
       File dellyVcf = delly2vcf.OutputVcf
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
   }
}
