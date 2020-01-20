version 1.0

import "tasks/common.wdl" as common
import "tasks/delly.wdl" as delly
import "tasks/manta.wdl" as manta
import "tasks/picard.wdl" as picard
import "tasks/bcftools.wdl" as bcftools
import "tasks/survivor.wdl" as survivor
import "tasks/clever.wdl" as clever
import "tasks/bwa.wdl" as bwa

workflow SVcalling {
    input {
        IndexedBamFile bamFile
        Reference reference
        BwaIndex bwaIndex
        String sample
        String outputDir = "."
    }
     
    call delly.CallSV as delly {
        input:
            bamFile = bamFile,
            reference = reference,
            outputPath = outputDir + '/delly/' + sample + ".delly.bcf"
    }   

    call bcftools.Bcf2Vcf as delly2vcf {
        input:
            bcf = delly.dellyBcf,
            outputPath = outputDir + '/delly/' + sample + ".delly.vcf"
    } 

    call clever.Prediction as clever {
        input:
            bamFile = bamFile,
            bwaIndex = bwaIndex,
            outputPath = outputDir + '/clever/'
    } 
    
    call FilterShortReadsBam {
        input:
            bamFile = bamFile,
            outputPathBam = outputDir + '/filteredBam/' + sample + ".filtered.bam"
    }

    call clever.Mateclever as mateclever {
        input:
            fiteredBamFile = FilterShortReadsBam.filteredBamOut,
            indexedFiteredBamFile = FilterShortReadsBam.filteredBamOutIndexed,
            bwaIndex = bwaIndex,
            predictions = clever.predictions,
            outputPath = outputDir + '/mateclever/'
    }

    call manta.Germline as manta {
        input:
            normalBam = bamFile,
            reference = reference,
            runDir = outputDir + '/manta/'
    }
 
    Array[Pair[File,String]] vcfAndCaller = [(delly2vcf.OutputVcf, "delly"),(manta.diploidSV.file,"manta"), 
        (mateclever.matecleverVcf, "clever")]

    scatter (pair in vcfAndCaller){
        call picard.RenameSample as renameSample {
            input:
                inputVcf = pair.left,
                outputPath = outputDir + '/modifiedVCFs/' + sample + "." + pair.right + '.vcf',
                newSampleName = sample + "." + pair.right 
        }
    }
    
    call survivor.Merge as survivor {
        input:
            filePaths = renameSample.renamedVcf,
            sample = sample,
            outputPath = outputDir + '/survivor/' + sample + '.merged.vcf'
    }
    
    output {
        File cleverPredictions = clever.predictions
        File cleverVcf = mateclever.matecleverVcf
        IndexedVcfFile mantaVcf = manta.diploidSV
        File dellyBcf = delly.dellyBcf
        File dellyVcf = delly2vcf.OutputVcf
        File survivorVcf = survivor.mergedVcf 
        Array[File] renamedVcfs = renameSample.renamedVcf 
    }
    
}


task FilterShortReadsBam {
    input {
        IndexedBamFile bamFile
        String outputPathBam
        String dockerImage = "quay.io/biocontainers/samtools:1.8--h46bd0b3_5"
    }

    command <<<
        set -e
        mkdir -p $(dirname ~{outputPathBam})
        samtools view -h ~{bamFile.file} | \
        awk 'length($10) > 30 || $1 ~/^@/' | \
        samtools view -bS -> ~{outputPathBam} 
        samtools index ~{outputPathBam}

    >>>

    output {
        File filteredBamOut = outputPathBam
        File filteredBamOutIndexed = outputPathBam+".bai"
    }

    runtime {
        docker: dockerImage
    }
}
