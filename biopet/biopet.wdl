version 1.0

import "../common.wdl"

task BaseCounter {
    input {
        String? preCommand
        File? toolJar
        IndexedBamFile bam
        File refFlat
        String outputDir
        String prefix

        Int memory = 4
        Float memoryMultiplier = 3.5
    }

    String toolCommand = if defined(toolJar)
        then "java -Xmx" + memory + "G -jar " +toolJar
        else "biopet-basecounter -Xmx" + memory + "G"

    command {
        set -e -o pipefail
        mkdir -p ~{outputDir}
        ~{preCommand}
        ~{toolCommand} \
        -b ~{bam.file} \
        -r ~{refFlat} \
        -o ~{outputDir} \
        -p ~{prefix}
    }

    output {
        File exonAntisense = outputDir + "/" + prefix + ".base.exon.antisense.counts"
        File exon = outputDir + "/" + prefix + ".base.exon.counts"
        File exonMergeAntisense = outputDir + "/" + prefix + ".base.exon.merge.antisense.counts"
        File exonMerge = outputDir + "/" + prefix + ".base.exon.merge.counts"
        File exonMergeSense = outputDir + "/" + prefix + ".base.exon.merge.sense.counts"
        File exonSense = outputDir + "/" + prefix + ".base.exon.sense.counts"
        File geneAntisense = outputDir + "/" + prefix + ".base.gene.antisense.counts"
        File gene = outputDir + "/" + prefix + ".base.gene.counts"
        File geneExonicAntisense = outputDir + "/" + prefix + ".base.gene.exonic.antisense.counts"
        File geneExonic = outputDir + "/" + prefix + ".base.gene.exonic.counts"
        File geneExonicSense = outputDir + "/" + prefix + ".base.gene.exonic.sense.counts"
        File geneIntronicAntisense = outputDir + "/" + prefix + ".base.gene.intronic.antisense.counts"
        File geneIntronic = outputDir + "/" + prefix + ".base.gene.intronic.counts"
        File geneIntronicSense = outputDir + "/" + prefix + ".base.gene.intronic.sense.counts"
        File geneSense = outputDir + "/" + prefix + ".base.gene.sense.counts"
        File intronAntisense = outputDir + "/" + prefix + ".base.intron.antisense.counts"
        File intron = outputDir + "/" + prefix + ".base.intron.counts"
        File intronMergeAntisense = outputDir + "/" + prefix + ".base.intron.merge.antisense.counts"
        File intronMerge = outputDir + "/" + prefix + ".base.intron.merge.counts"
        File intronMergeSense = outputDir + "/" + prefix + ".base.intron.merge.sense.counts"
        File intronSense = outputDir + "/" + prefix + ".base.intron.sense.counts"
        File metaExonsNonStranded = outputDir + "/" + prefix + ".base.metaexons.non_stranded.counts"
        File metaExonsStrandedAntisense = outputDir + "/" + prefix + ".base.metaexons.stranded.antisense.counts"
        File metaExonsStranded = outputDir + "/" + prefix + ".base.metaexons.stranded.counts"
        File metaExonsStrandedSense = outputDir + "/" + prefix + ".base.metaexons.stranded.sense.counts"
        File transcriptAntisense = outputDir + "/" + prefix + ".base.transcript.antisense.counts"
        File transcript = outputDir + "/" + prefix + ".base.transcript.counts"
        File transcriptExonicAntisense = outputDir + "/" + prefix + ".base.transcript.exonic.antisense.counts"
        File transcriptExonic = outputDir + "/" + prefix + ".base.transcript.exonic.counts"
        File transcriptExonicSense = outputDir + "/" + prefix + ".base.transcript.exonic.sense.counts"
        File transcriptIntronicAntisense = outputDir + "/" + prefix + ".base.transcript.intronic.antisense.counts"
        File transcriptIntronic = outputDir + "/" + prefix + ".base.transcript.intronic.counts"
        File transcriptIntronicSense = outputDir + "/" + prefix + ".base.transcript.intronic.sense.counts"
        File transcriptSense = outputDir + "/" + prefix + ".base.transcript.sense.counts"
    }

    runtime {
        memory: ceil(memory * memoryMultiplier)
    }
}

task ExtractAdaptersFastqc {
    input {
        File inputFile
        String outputDir
        String adapterOutputFilePath = outputDir + "/adapter.list"
        String contamsOutputFilePath = outputDir + "/contaminations.list"
        Boolean? skipContams
        File? knownContamFile
        File? knownAdapterFile
        Float? adapterCutoff
        Boolean? outputAsFasta

        Int memory = 8
        Float memoryMultiplier = 5 # This is ridiculous...
        String dockerTag = "0.2--1"
    }

    command {
        set -e
        mkdir -p ~{outputDir}
        biopet-extractadaptersfastqc -Xmx~{memory}G \
        --inputFile ~{inputFile} \
        ~{"--adapterOutputFile " + adapterOutputFilePath } \
        ~{"--contamsOutputFile " + contamsOutputFilePath } \
        ~{"--knownContamFile " + knownContamFile} \
        ~{"--knownAdapterFile " + knownAdapterFile} \
        ~{"--adapterCutoff " + adapterCutoff} \
        ~{true="--skipContams" false="" skipContams} \
        ~{true="--outputAsFasta" false="" outputAsFasta}
    }

    output {
        File adapterOutputFile = adapterOutputFilePath
        File contamsOutputFile = contamsOutputFilePath
        Array[String] adapterList = read_lines(adapterOutputFile)
        Array[String] contamsList = read_lines(contamsOutputFile)
    }

    runtime {
        memory: ceil(memory * memoryMultiplier)
        docker: "quay.io/biocontainers/biopet-extractadaptersfastqc:" + dockerTag
    }
}

task FastqSplitter {
    input {
        String? preCommand
        File inputFastq
        Array[String]+ outputPaths
        File? toolJar

        Int memory = 4
        Float memoryMultiplier = 3
        String dockerTag = "0.1--2"
    }

    command {
        set -e
        mkdir -p $(dirname ~{sep=') $(dirname ' outputPaths})
        biopet-fastqsplitter -Xmx~{memory}G \
        -I ~{inputFastq} \
        -o ~{sep=' -o ' outputPaths}
    }

    output {
        Array[File] chunks = outputPaths
    }
    
    runtime {
        memory: ceil(memory * memoryMultiplier)
        docker: "quay.io/biocontainers/biopet-fastqsplitter:" + dockerTag
    }
}

task FastqSync {
    input {
        String? preCommand
        FastqPair refFastq
        FastqPair inputFastq
        String out1path
        String out2path
        File? toolJar

        Int memory = 4
        Float memoryMultiplier = 2.5
    }

    String toolCommand = if defined(toolJar)
        then "java -Xmx" + memory + "G -jar " +toolJar
        else "biopet-fastqsync -Xmx" + memory + "G"

    command {
        set -e -o pipefail
        ~{preCommand}
        mkdir -p $(dirname ~{out1path}) $(dirname ~{out2path})
        ~{toolCommand} \
        --in1 ~{inputFastq.R1} \
        --in2 ~{inputFastq.R2} \
        --ref1 ~{refFastq.R1} \
        --ref2 ~{refFastq.R2} \
        --out1 ~{out1path} \
        --out2 ~{out2path}
    }

    output {
        FastqPair out1 = object {
          R1: out1path,
          R2: out2path
        }
    }
    
    runtime {
        memory: ceil(memory * memoryMultiplier)
    }
}

task ReorderGlobbedScatters {
    input {
        Array[File]+ scatters

        # Should not be changed from the main pipeline. As it should not influence results.
        # The 3.7-slim container is 143 mb on the filesystem. 3.7 is 927 mb.
        # The slim container is sufficient for this small task.
        String dockerTag = "3.7-slim"
    }

    command <<<
       set -e
       # Copy all the scatter files to the CWD so the output matches paths in
       # the cwd.
       for file in ~{sep=" " scatters}
          do cp $file .
       done
       python << CODE
       from os.path import basename
       scatters = ['~{sep="','" scatters}']
       splitext = [basename(x).split(".") for x in scatters]
       splitnum = [x.split("-") + [y] for x,y in splitext]
       ordered = sorted(splitnum, key=lambda x: int(x[1]))
       merged = ["{}-{}.{}".format(x[0],x[1],x[2]) for x in ordered]
       for x in merged:
           print(x)
       CODE
    >>>

    output {
        Array[File] reorderedScatters = read_lines(stdout())
    }

    runtime {
        docker: "python:" + dockerTag
        # 4 gigs of memory to be able to build the docker image in singularity
        memory: 4
    }
}

task ScatterRegions {
    input {
        File referenceFasta
        File referenceFastaDict
        Int? scatterSize
        File? regions
        Boolean notSplitContigs = false
        File? bamFile
        File? bamIndex

        Int memory = 8
        Float memoryMultiplier = 3.0
        String dockerImage = "quay.io/biocontainers/biopet-scatterregions:0.2--0"
    }

    # OutDirPath must be defined here because the glob process relies on
    # linking. This path must be in the containers filesystem, otherwise the
    # linking does not work.
    String outputDirPath = "scatters"

    command {
        set -e -o pipefail
        mkdir -p ~{outputDirPath}
        biopet-scatterregions -Xmx~{memory}G \
          -R ~{referenceFasta} \
          -o ~{outputDirPath} \
          ~{"-s " + scatterSize} \
          ~{"-L " + regions} \
          ~{"--bamFile " + bamFile} \
          ~{true="--notSplitContigs" false="" notSplitContigs}
    }

    output {
        Array[File] scatters = glob(outputDirPath + "/scatter-*.bed")
    }

    runtime {
        docker: dockerImage
        memory: ceil(memory * memoryMultiplier)
    }
}

task ValidateAnnotation {
    input {
        File? refRefflat
        File? gtfFile
        Reference reference

        Int memory = 3
        Float memoryMultiplier = 3.0
        String dockerTag = "0.1--0"
    }

    command {
        biopet-validateannotation -Xmx~{memory}G \
        ~{"-r " + refRefflat} \
        ~{"-g " + gtfFile} \
        -R ~{reference.fasta}
    }

    output {
        File stderr = stderr()
    }

    runtime {
        memory: ceil(memory * memoryMultiplier)
        docker: "quay.io/biocontainers/biopet-validateannotation:" + dockerTag
    }
}

task ValidateFastq {
    input {
        File read1
        File? read2
        Int memory = 3
        Float memoryMultiplier = 3.0
        String dockerTag = "0.1.1--1"
    }

    command {
        biopet-validatefastq -Xmx~{memory}G \
        --fastq1 ~{read1} \
        ~{"--fastq2 " + read2}
    }

    output {
        File stderr = stderr()
    }

    runtime {
        memory: ceil(memory * memoryMultiplier)
        docker: "quay.io/biocontainers/biopet-validatefastq" + dockerTag
    }
}

task ValidateVcf {
    input {
        IndexedVcfFile vcf
        Reference reference
        Int memory = 3
        Float memoryMultiplier = 3.0
        String dockerTag = "0.1--0"
    }

    command {
        biopet-validatevcf -Xmx~{memory}G \
        -i ~{vcf.file} \
        -R ~{reference.fasta}
    }

    output {
        File stderr = stderr()
    }

    runtime {
        memory: ceil(memory * memoryMultiplier)
        docker: "quay.io/biocontainers/biopet-validatevcf:" + dockerTag
    }
}

task VcfStats {
    input {
        IndexedVcfFile vcf
        Reference reference
        String outputDir
        File? intervals
        Array[String]+? infoTags
        Array[String]+? genotypeTags
        Int? sampleToSampleMinDepth
        Int? binSize
        Int? maxContigsInSingleJob
        Boolean writeBinStats = false
        Int localThreads = 1
        Boolean notWriteContigStats = false
        Boolean skipGeneral = false
        Boolean skipGenotype = false
        Boolean skipSampleDistributions = false
        Boolean skipSampleCompare = false
        String? sparkMaster
        Int? sparkExecutorMemory
        Array[String]+? sparkConfigValues

        String dockerTag = "1.2--0"
        Int memory = 4
        Float memoryMultiplier = 3
    }


    command {
        set -e
        mkdir -p ~{outputDir}
        biopet-vcfstats -Xmx~{memory}G \
        -I ~{vcf.file} \
        -R ~{reference.fasta} \
        -o ~{outputDir} \
        -t ~{localThreads} \
        ~{"--intervals " + intervals} \
        ~{true="--infoTag" false="" defined(infoTags)} ~{sep=" --infoTag " infoTags} \
        ~{true="--genotypeTag" false="" defined(genotypeTags)} ~{sep=" --genotypeTag "
            genotypeTags} \
        ~{"--sampleToSampleMinDepth " + sampleToSampleMinDepth} \
        ~{"--binSize " + binSize} \
        ~{"--maxContigsInSingleJob " + maxContigsInSingleJob} \
        ~{true="--writeBinStats" false="" writeBinStats} \
        ~{true="--notWriteContigStats" false="" notWriteContigStats} \
        ~{true="--skipGeneral" false="" skipGeneral} \
        ~{true="--skipGenotype" false="" skipGenotype} \
        ~{true="--skipSampleDistributions" false="" skipSampleDistributions} \
        ~{true="--skipSampleCompare" false="" skipSampleCompare} \
        ~{"--sparkMaster " + sparkMaster} \
        ~{"--sparkExecutorMemory " + sparkExecutorMemory} \
        ~{true="--sparkConfigValue" false="" defined(sparkConfigValues)} ~{
            sep=" --sparkConfigValue" sparkConfigValues}
    }

    output {
        File? general = outputDir + "/general.tsv"
        File? genotype = outputDir + "/genotype.tsv"
        File? sampleDistributionAvailableAggregate = outputDir +
            "/sample_distributions/Available.aggregate.tsv"
        File? sampleDistributionAvailable = outputDir + "/sample_distributions/Available.tsv"
        File? sampleDistributionCalledAggregate = outputDir +
            "/sample_distributions/Called.aggregate.tsv"
        File? sampleDistributionCalled = outputDir + "/sample_distributions/Called.tsv"
        File? sampleDistributionFilteredAggregate = outputDir +
            "/sample_distributions/Filtered.aggregate.tsv"
        File? sampleDistributionFiltered = outputDir + "/sample_distributions/Filtered.tsv"
        File? sampleDistributionHetAggregate = outputDir + "/sample_distributions/Het.aggregate.tsv"
        File? sampleDistributionHetNoNRefAggregate = outputDir +
            "/sample_distributions/HetNonRef.aggregate.tsv"
        File? sampleDistributionHetNonRef = outputDir + "/sample_distributions/HetNonRef.tsv"
        File? sampleDistributionHet = outputDir + "/sample_distributions/Het.tsv"
        File? sampleDistributionHomAggregate = outputDir + "/sample_distributions/Hom.aggregate.tsv"
        File? sampleDistributionHomRefAggregate = outputDir +
            "/sample_distributions/HomRef.aggregate.tsv"
        File? sampleDistributionHomRef = outputDir + "/sample_distributions/HomRef.tsv"
        File? sampleDistributionHom = outputDir + "/sample_distributions/Hom.tsv"
        File? sampleDistributionHomVarAggregate = outputDir +
            "/sample_distributions/HomVar.aggregate.tsv"
        File? sampleDistributionHomVar = outputDir + "/sample_distributions/HomVar.tsv"
        File? sampleDistributionMixedAggregate = outputDir +
            "/sample_distributions/Mixed.aggregate.tsv"
        File? sampleDistributionMixed = outputDir + "/sample_distributions/Mixed.tsv"
        File? sampleDistributionNoCallAggregate = outputDir +
            "/sample_distributions/NoCall.aggregate.tsv"
        File? sampleDistributionNoCall = outputDir + "/sample_distributions/NoCall.tsv"
        File? sampleDistributionNonInformativeAggregate = outputDir +
            "/sample_distributions/NonInformative.aggregate.tsv"
        File? sampleDistributionNonInformative = outputDir +
            "/sample_distributions/NonInformative.tsv"
        File? sampleDistributionToalAggregate = outputDir +
            "/sample_distributions/Total.aggregate.tsv"
        File? sampleDistributionTotal = outputDir + "/sample_distributions/Total.tsv"
        File? sampleDistributionVariantAggregate = outputDir +
            "/sample_distributions/Variant.aggregate.tsv"
        File? sampleDistributionVariant = outputDir + "/sample_distributions/Variant.tsv"
        File? sampleCompareAlleleAbs = outputDir + "/sample_compare/allele.abs.tsv"
        File? sampleCompareAlleleNonRefAbs = outputDir + "/sample_compare/allele.non_ref.abs.tsv"
        File? sampleCompareAlleleRefAbs = outputDir + "/sample_compare/allele.ref.abs.tsv"
        File? sampleCompareAlleleRel = outputDir + "/sample_compare/allele.rel.tsv"
        File? sampleCompareGenotypeAbs = outputDir + "/sample_compare/genotype.abs.tsv"
        File? sampleCompareGenotypeNonRefAbs = outputDir +
            "/sample_compare/genotype.non_ref.abs.tsv"
        File? sampleCompareGenotypeRefAbs = outputDir + "/sample_compare/genotype.ref.abs.tsv"
        File? sampleCompareGenotypeRel = outputDir + "/sample_compare/genotype.rel.tsv"
        # A glob is easier, but duplicates all the outputs
        Array[File] allStats = select_all([
            general,
            genotype,
            sampleDistributionAvailableAggregate,
            sampleDistributionAvailable,
            sampleDistributionCalledAggregate,
            sampleDistributionCalled,
            sampleDistributionFilteredAggregate,
            sampleDistributionFiltered,
            sampleDistributionHetAggregate,
            sampleDistributionHetNoNRefAggregate,
            sampleDistributionHetNonRef,
            sampleDistributionHet,
            sampleDistributionHomAggregate,
            sampleDistributionHomRefAggregate,
            sampleDistributionHomRef,
            sampleDistributionHom,
            sampleDistributionHomVarAggregate,
            sampleDistributionHomVar,
            sampleDistributionMixedAggregate,
            sampleDistributionMixed,
            sampleDistributionNoCallAggregate,
            sampleDistributionNoCall,
            sampleDistributionNonInformativeAggregate,
            sampleDistributionNonInformative,
            sampleDistributionToalAggregate,
            sampleDistributionTotal,
            sampleDistributionVariantAggregate,
            sampleDistributionVariant,
            sampleCompareAlleleAbs,
            sampleCompareAlleleNonRefAbs,
            sampleCompareAlleleRefAbs,
            sampleCompareAlleleRel,
            sampleCompareGenotypeAbs,
            sampleCompareGenotypeNonRefAbs,
            sampleCompareGenotypeRefAbs,
            sampleCompareGenotypeRel
        ])
    }

    runtime {
        cpu: localThreads
        memory: ceil(memory * memoryMultiplier)
        docker: "quay.io/biocontainers/biopet-vcfstats:" + dockerTag
    }
}
