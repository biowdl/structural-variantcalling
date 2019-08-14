version 1.0

task BedToIntervalList {
    input {
        File bedFile
        File dict
        String outputPath

        Int memory = 4
        Float memoryMultiplier = 3.0
        String dockerImage = "quay.io/biocontainers/picard:2.20.5--0"
    }

    command {
        set -e
        mkdir -p $(dirname "~{outputPath}")
        picard -Xmx~{memory}G \
        BedToIntervalList \
        I=~{bedFile} \
        O=~{outputPath} \
        SD=~{dict}
    }

    output {
        File intervalList = outputPath
    }

    runtime {
        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}

task CollectMultipleMetrics {
    input {
        File inputBam
        File inputBamIndex
        File referenceFasta
        File referenceFastaDict
        File referenceFastaFai
        String basename

        Boolean collectAlignmentSummaryMetrics = true
        Boolean collectInsertSizeMetrics = true
        Boolean qualityScoreDistribution = true
        Boolean meanQualityByCycle = true
        Boolean collectBaseDistributionByCycle = true
        Boolean collectGcBiasMetrics = true
        #FIXME: Boolean rnaSeqMetrics = false # There is a bug in picard https://github.com/broadinstitute/picard/issues/999
        Boolean collectSequencingArtifactMetrics = true
        Boolean collectQualityYieldMetrics = true

        Int memory = 8
        Float memoryMultiplier = 4
        String dockerImage = "quay.io/biocontainers/picard:2.20.5--0"
    }


    command {
        set -e
        mkdir -p $(dirname "~{basename}")
        picard -Xmx~{memory}G \
        CollectMultipleMetrics \
        I=~{inputBam} \
        R=~{referenceFasta} \
        O=~{basename} \
        PROGRAM=null \
        ~{true="PROGRAM=CollectAlignmentSummaryMetrics" false="" collectAlignmentSummaryMetrics} \
        ~{true="PROGRAM=CollectInsertSizeMetrics" false="" collectInsertSizeMetrics} \
        ~{true="PROGRAM=QualityScoreDistribution" false="" qualityScoreDistribution} \
        ~{true="PROGRAM=MeanQualityByCycle" false="" meanQualityByCycle} \
        ~{true="PROGRAM=CollectBaseDistributionByCycle" false="" collectBaseDistributionByCycle} \
        ~{true="PROGRAM=CollectGcBiasMetrics" false="" collectGcBiasMetrics} \
        ~{true="PROGRAM=CollectSequencingArtifactMetrics" false=""
            collectSequencingArtifactMetrics} \
        ~{true="PROGRAM=CollectQualityYieldMetrics" false="" collectQualityYieldMetrics}
    }

    output {
        File alignmentSummary = basename + ".alignment_summary_metrics"
        File baitBiasDetail = basename + ".bait_bias_detail_metrics"
        File baitBiasSummary = basename + ".bait_bias_summary_metrics"
        File baseDistributionByCycle = basename + ".base_distribution_by_cycle_metrics"
        File baseDistributionByCyclePdf = basename + ".base_distribution_by_cycle.pdf"
        File errorSummary = basename + ".error_summary_metrics"
        File gcBiasDetail = basename + ".gc_bias.detail_metrics"
        File gcBiasPdf = basename + ".gc_bias.pdf"
        File gcBiasSummary = basename + ".gc_bias.summary_metrics"
        File? insertSizeHistogramPdf = basename + ".insert_size_histogram.pdf"
        File? insertSize = basename + ".insert_size_metrics"
        File preAdapterDetail = basename + ".pre_adapter_detail_metrics"
        File preAdapterSummary = basename + ".pre_adapter_summary_metrics"
        File qualityByCycle = basename + ".quality_by_cycle_metrics"
        File qualityByCyclePdf = basename + ".quality_by_cycle.pdf"
        File qualityDistribution = basename + ".quality_distribution_metrics"
        File qualityDistributionPdf = basename + ".quality_distribution.pdf"
        File qualityYield = basename + ".quality_yield_metrics"
        # Using a glob is easier. But will lead to very ugly output directories.
        Array[File] allStats = select_all([
            alignmentSummary,
            baitBiasDetail,
            baitBiasSummary,
            baseDistributionByCycle,
            baseDistributionByCyclePdf,
            errorSummary,
            gcBiasDetail,
            gcBiasPdf,
            gcBiasSummary,
            insertSizeHistogramPdf,
            insertSize,
            preAdapterDetail,
            preAdapterSummary,
            qualityByCycle,
            qualityByCyclePdf,
            qualityDistribution,
            qualityDistributionPdf,
            qualityYield
        ])
    }

    runtime {

        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}

task CollectRnaSeqMetrics {
    input {
        File inputBam
        File inputBamIndex
        File refRefflat
        String basename
        String strandSpecificity = "NONE"

        Int memory = 8
        Float memoryMultiplier = 4.0
        String dockerImage = "quay.io/biocontainers/picard:2.20.5--0"
    }

    command {
        set -e
        mkdir -p $(dirname "~{basename}")
        picard -Xmx~{memory}G \
        CollectRnaSeqMetrics \
        I=~{inputBam} \
        O=~{basename}.RNA_Metrics \
        CHART_OUTPUT=~{basename}.RNA_Metrics.pdf \
        STRAND_SPECIFICITY=~{strandSpecificity} \
        REF_FLAT=~{refRefflat}
    }

    output {
        File? chart = basename + ".RNA_Metrics.pdf"
        File metrics = basename + ".RNA_Metrics"
    }

    runtime {
        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}

task CollectTargetedPcrMetrics {
    input {
        File inputBam
        File inputBamIndex
        File referenceFasta
        File referenceFastaDict
        File referenceFastaFai
        File ampliconIntervals
        Array[File]+ targetIntervals
        String basename

        Int memory = 4
        Float memoryMultiplier = 3.0
        String dockerImage = "quay.io/biocontainers/picard:2.20.5--0"
    }

    command {
        set -e
        mkdir -p $(dirname "~{basename}")
        picard -Xmx~{memory}G \
        CollectTargetedPcrMetrics \
        I=~{inputBam} \
        R=~{referenceFasta} \
        AMPLICON_INTERVALS=~{ampliconIntervals} \
        TARGET_INTERVALS=~{sep=" TARGET_INTERVALS=" targetIntervals} \
        O=~{basename}.targetPcrMetrics \
        PER_BASE_COVERAGE=~{basename}.targetPcrPerBaseCoverage \
        PER_TARGET_COVERAGE=~{basename}.targetPcrPerTargetCoverage
    }

    output {
        File perTargetCoverage = basename + ".targetPcrPerTargetCoverage"
        File perBaseCoverage = basename + ".targetPcrPerBaseCoverage"
        File metrics = basename + ".targetPcrMetrics"
    }

    runtime {
        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}

# Combine multiple recalibrated BAM files from scattered ApplyRecalibration runs
task GatherBamFiles {
    input {
        Array[File]+ inputBams
        Array[File]+ inputBamsIndex
        String outputBamPath

        Int memory = 4
        Float memoryMultiplier = 3.0
        String dockerImage = "quay.io/biocontainers/picard:2.20.5--0"
    }

    command {
        set -e
        mkdir -p $(dirname ~{outputBamPath})
        picard -Xmx~{memory}G \
        GatherBamFiles \
        INPUT=~{sep=' INPUT=' inputBams} \
        OUTPUT=~{outputBamPath} \
        CREATE_INDEX=true \
        CREATE_MD5_FILE=true
    }

    output {
        File outputBam = outputBamPath
        File outputBamIndex = sub(outputBamPath, "\.bam$", ".bai")
        File outputBamMd5 = outputBamPath + ".md5"
    }

    runtime {
        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}

task GatherVcfs {
    input {
        Array[File]+ inputVcfs
        Array[File]+ inputVcfIndexes
        String outputVcfPath = "out.vcf.gz"

        Int memory = 4
        Float memoryMultiplier = 3.0
        String dockerImage = "quay.io/biocontainers/picard:2.20.5--0"
    }

    command {
        set -e
        mkdir -p $(dirname ~{outputVcfPath})
        picard -Xmx~{memory}G \
        GatherVcfs \
        INPUT=~{sep=' INPUT=' inputVcfs} \
        OUTPUT=~{outputVcfPath}
    }

    output {
        File outputVcf = outputVcfPath
    }

    runtime {
        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}

# Mark duplicate reads to avoid counting non-independent observations
task MarkDuplicates {
    input {
        Array[File]+ inputBams
        Array[File] inputBamIndexes
        String outputBamPath
        String metricsPath

        Int memory = 8
        Float memoryMultiplier = 3.0
        String dockerImage = "quay.io/biocontainers/picard:2.20.5--0"

        # The program default for READ_NAME_REGEX is appropriate in nearly every case.
        # Sometimes we wish to supply "null" in order to turn off optical duplicate detection
        # This can be desirable if you don't mind the estimated library size being wrong and
        # optical duplicate detection is taking >7 days and failing
        String? read_name_regex
    }

    # Task is assuming query-sorted input so that the Secondary and Supplementary reads get
    # marked correctly. This works because the output of BWA is query-grouped and therefore,
    # so is the output of MergeBamAlignment. While query-grouped isn't actually query-sorted,
    # it's good enough for MarkDuplicates with ASSUME_SORT_ORDER="queryname"

    command {
        set -e
        mkdir -p $(dirname ~{outputBamPath})
        picard -Xmx~{memory}G \
        MarkDuplicates \
        INPUT=~{sep=' INPUT=' inputBams} \
        OUTPUT=~{outputBamPath} \
        METRICS_FILE=~{metricsPath} \
        VALIDATION_STRINGENCY=SILENT \
        ~{"READ_NAME_REGEX=" + read_name_regex} \
        OPTICAL_DUPLICATE_PIXEL_DISTANCE=2500 \
        CLEAR_DT="false" \
        CREATE_INDEX=true \
        ADD_PG_TAG_TO_READS=false \
        CREATE_MD5_FILE=true
    }

    output {
        File outputBam = outputBamPath
        File outputBamIndex = sub(outputBamPath, "\.bam$", ".bai")
        File outputBamMd5 = outputBamPath + ".md5"
        File metricsFile = metricsPath
    }

    runtime {
        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}

# Combine multiple VCFs or GVCFs from scattered HaplotypeCaller runs
task MergeVCFs {
    input {
        Array[File]+ inputVCFs
        Array[File]+ inputVCFsIndexes
        String outputVcfPath

        Int memory = 8
        Float memoryMultiplier = 3.0
        String dockerImage = "quay.io/biocontainers/picard:2.20.5--0"
    }

    # Using MergeVcfs instead of GatherVcfs so we can create indices
    # See https://github.com/broadinstitute/picard/issues/789 for relevant GatherVcfs ticket

    command {
        set -e
        mkdir -p $(dirname ~{outputVcfPath})
        picard -Xmx~{memory}G \
        MergeVcfs \
        INPUT=~{sep=' INPUT=' inputVCFs} \
        OUTPUT=~{outputVcfPath}
    }

    output {
        File outputVcf = outputVcfPath
        File outputVcfIndex = outputVcfPath + ".tbi"
    }

    runtime {
        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}

task SamToFastq {
    input {
        File inputBam
        File inputBamIndex
        Boolean paired = true

        Int memory = 16 # High memory default to avoid crashes.
        Float memoryMultiplier = 3.0
        String dockerImage = "quay.io/biocontainers/picard:2.20.5--0"
        File? NONE
    }

    String outputRead1 = basename(inputBam, "\.[bs]am") + "_R1.fastq.gz"
    String outputRead2 = basename(inputBam, "\.[bs]am") + "_R2.fastq.gz"
    String outputUnpaired = basename(inputBam, "\.[bs]am") + "_unpaired.fastq.gz"

    command {
        set -e
        picard -Xmx~{memory}G \
        SamToFastq \
        I=~{inputBam} \
        ~{"FASTQ=" + outputRead1} \
        ~{if paired then "SECOND_END_FASTQ=" + outputRead2 else ""} \
        ~{if paired then "UNPAIRED_FASTQ=" + outputUnpaired else ""}
    }

    output {
        File read1 = outputRead1
        File? read2 = if paired then outputRead2 else NONE
        File? unpairedRead = if paired then outputUnpaired else NONE
    }

    runtime {
        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}

task ScatterIntervalList {
    input {
        File interval_list
        Int scatter_count

        Int memory = 4
        Float memoryMultiplier = 3.0
        String dockerImage = "quay.io/biocontainers/picard:2.20.5--0"
    }

    command {
        set -e
        mkdir scatter_list
        picard -Xmx~{memory}G \
        IntervalListTools \
        SCATTER_COUNT=~{scatter_count} \
        SUBDIVISION_MODE=BALANCING_WITHOUT_INTERVAL_SUBDIVISION_WITH_OVERFLOW \
        UNIQUE=true \
        SORT=true \
        INPUT=~{interval_list} \
        OUTPUT=scatter_list
    }

    output {
        Array[File] out = glob("scatter_list/*/*.interval_list")
        Int interval_count = read_int(stdout())
    }

    runtime {
        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}

task SortVcf {
    input {
        Array[File]+ vcfFiles
        String outputVcfPath
        File? dict

        Int memory = 8
        Float memoryMultiplier = 3.0
        String dockerImage = "quay.io/biocontainers/picard:2.20.5--0"
        }


    command {
        set -e
        mkdir -p $(dirname ~{outputVcfPath})
        picard -Xmx~{memory}G \
        SortVcf \
        I=~{sep=" I=" vcfFiles} \
        ~{"SEQUENCE_DICTIONARY=" + dict} \
        O=~{outputVcfPath}
    }

    output {
        File outputVcf = outputVcfPath
        File outputVcfIndex = outputVcfPath + ".tbi"
    }

    runtime {
        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}