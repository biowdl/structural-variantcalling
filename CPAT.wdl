version 1.0

task CPAT {
    input {
        File gene
        String outFilePath
        File hex
        File logitModel
        File? referenceGenome
        File? referenceGenomeIndex  # Should be added as input if
        # CPAT should not index the reference genome.
        Array[String]? startCodons
        Array[String]? stopCodons
        String dockerImage = "biocontainers/cpat:v1.2.4_cv1"
    }

    # Some WDL magic in the command section to properly output the start and stopcodons to the command.
    # select_first is needed in order to convert the optional arrays to non-optionals.
    command {
        set -e
        mkdir -p $(dirname ~{outFilePath})
        cpat.py \
        --gene ~{gene} \
        --outfile ~{outFilePath} \
        --hex ~{hex} \
        --logitModel ~{logitModel} \
        ~{"--ref " + referenceGenome} \
        ~{true="--start" false="" defined(startCodons)} ~{sep="," select_first([startCodons, [""]])} \
        ~{true="--stop" false="" defined(stopCodons)} ~{sep="," select_first([stopCodons, [""]])}
    }

    output {
        File outFile=outFilePath
    }

    runtime {
        docker: dockerImage
    }
}

# There is also make_hexamer_tab.py and make_logitModel.py
# that can be added as tasks here.