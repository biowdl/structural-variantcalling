version 1.0

import "tasks/delly.wdl" as delly
import "tasks/clever.wdl" as clever
import "tasks/pindel.wdl" as pindel
import "tasks/bcftools.wdl" as bcftools
import "tasks/listing.wdl" as listing
import "tasks/survivor.wdl" as survivor
import "tasks/statistics.wdl" as statistics
import "tasks/upSet.wdl" as upSet

workflow pipeline {
    input {
        File bam
        String sample
    }

    call delly.discover as delly {
        input:
            bam = "/home/cagaser/structural-variantcalling/data/bam/Delly_HG00514_CHS_HGSV.all.vcf",
            caller = "Delly"
    }

    call clever.discover as clever {
        input:
            bam = "/home/cagaser/structural-variantcalling/data/bam/Clever_HG00514_CHS_HGSV.all.vcf",
            caller = "Clever"
    }

    call pindel.discover as pindel {
        input:
            bam = "/home/cagaser/structural-variantcalling/data/bam/Pindel_HG00514_CHS_HGSV.all.D.vcf",
            caller = "Pindel"
    }

    Array[Pair[String, File]] pairs = [delly.dellyPair, clever.cleverPair, pindel.pindelPair]
    scatter (pair in pairs) {
        call bcftools.rehead as rehead {
        input:
            pair = pair
        }
    }
#
    call listing.listing as listing {
        input:
            reheaded_vcfs = rehead.reheaded,
            script = "/home/cagaser/structural-variantcalling/scripts/listing.sh",
            sample = sample
    }

    call survivor.merge as merge {
        input:
            sampleCallersList = listing.paths,
            suppVecs = 2,
            breakpointDistance = 1000,
            svType = 1,
            strandType = 1,
            distanceBySvSize = 0,
            minSize = 30,
            sample = sample
    }

    call statistics.getStats as getStats {
        input:
            vcf = merge.merged,
            script = "/home/cagaser/structural-variantcalling/scripts/statistics.py",
            sample = sample
    }

    call upSet.getUpSet as upSet {
        input:
            csv = getStats.stats,
            script = "/home/cagaser/structural-variantcalling/scripts/getUpSet.R",
            outDir = "/home/cagaser/structural-variantcalling/UpSetsDir/",
            sample = sample
    }


}