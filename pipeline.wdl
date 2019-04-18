version 1.0

import "tasks/common.wdl" as common
import "tasks/delly.wdl" as delly
import "tasks/manta.wdl" as manta
import "tasks/picard.wdl" as picard
import "tasks/bcftools.wdl" as bcftools
import "tasks/survivor.wdl" as survivor
import "tasks/clever.wdl" as clever
import "tasks/lumpy.wdl" as lumpy

workflow SVcalling {
    input {
        IndexedBamFile bamFile
        Reference reference
        String sample
        String outputDir
    }
     
    call delly.CallSV as delly {
        input:
            bamFile = bamFile,
            reference = reference,
            outputPath = outputDir + '/' + sample + ".delly.bcf"
    }   

#Dpendencies issues: missing bwa in the container
#    call clever.Prediction as clever {
#        input:
#            bamFile = bamFile,
#            reference = reference,
#            outputPath = outputDir + '/' + sample + ".clever"
#    } 
    
#    call clever.Mateclever as mateclever {
#        input:
#            bamFile = bamFile,
#            reference = reference,
#            predictions = clever.predictions,
#            outputPath = outputDir + '/' + sample + ".clever"
#    }

## dependencies issue: still missing hexdump    
#    call lumpy.CallSV as lumpy {
#        input:
#            bamFile = bamFile,
#            reference = reference,
#            outputPath = outputDir + '/' + sample + ".lumpy"
#    }

    
    call manta.Germline as manta {
        input:
            normalBam = bamFile,
            reference = reference,
            runDir = outputDir + '/' + sample + ".manta"
    }
    
    call bcftools.Bcf2Vcf as delly2vcf {
        input:
            bcf = delly.dellyVcf,
            outputPath = outputDir + '/' + sample + ".delly"
    } 

#use this when clever is fixed
#    Array[Pair[File,String]] vcfAndCaller = [(delly2vcf.OutputVcf, "delly"),(manta.diploidSV.file,"manta"), 
#        (mateclever.matecleverVcf, "clever")]
    Array[Pair[File,String]] vcfAndCaller = [(delly2vcf.OutputVcf, "delly"),(manta.diploidSV.file,"manta")]
  
    scatter (pair in vcfAndCaller){
        call picard.RenameSample as renameSample {
            input:
                inputVcf = pair.left,
                outputPath = sample + "." + pair.right + '.vcf',
                newSampleName = sample + "." + pair.right 
        }
    }
    
    call survivor.Merge as survivor {
        input:
            filePaths = renameSample.renamedVcf,
            sample = sample,
            outputPath = outputDir + '/' + sample + 'merged.vcf'
    }
}
