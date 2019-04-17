version 1.0

import "tasks/common.wdl" as common
import "tasks/delly.wdl" as delly
import "tasks/manta.wdl" as manta
import "tasks/picard.wdl" as picard
import "tasks/bcftools.wdl" as bcftools
import "tasks/survivor.wdl" as survivor
import "tasks/clever.wdl" as clever
import "tasks/lumpy.wdl" as lumpy

workflow SV-calling {
    input {
        IndexedBamFile bamFile
        Reference reference
        String sample
    }
 
    call delly.CallSV as delly {
        input:
            bamFile = bamFile,
            reference = reference,
            outputPath = sample + ".delly.bcf"
    }   

    call clever.Prediction as clever {
        input:
            bamFile = bamFile,
            reference = reference,
            outputPath = sample + ".clever"
    } 
    
    call clever.Mateclever as mateclever {
        input:
            bamFile = bamFile,
            reference = reference,
            predictions = clever.predictions,
            outputPath = sample + ".clever"
    }
    
#    call lumpy.CallSV as lumpy {
#        input:
#            bamFile = bamFile,
#            reference = reference,
#            outputPath = sample + ".lumpy"
#    }

    
    call manta.Germline as manta {
        input:
            normalBam = bamFile,
            reference = reference,
            runDir = sample + ".manta"
    }
    
    call bcftools.Bcf2Vcf as delly2vcf {
        input:
            bcf = delly.dellyVcf,
            outputPath = sample + ".delly"
    } 

    Array[Pair[File,String]] pairs = [(delly2vcf.OutputVcf, "delly"),(manta.diploidSV.file,"manta"), 
        (mateclever.matecleverVcf, "clever")]
    
    scatter (pair in pairs){
        call picard.RenameSample as renameSample {
            input:
                inputVcf = pair.left,
                newSampleName = sample + "." + pair.right 
        }
    }
    
    File filePaths = write_lines(renameSample.renamedVcf)
       
    call survivor.Merge as survivor {
        input:
            filePaths = filePaths,
            sample = sample
    }
}
