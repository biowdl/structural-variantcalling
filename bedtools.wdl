version 1.0

# Copyright (c) 2017 Leiden University Medical Center
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

task Complement {
    input {
        File faidx
        File inputBed
        String dockerImage = "quay.io/biocontainers/bedtools:2.23.0--hdbcaa40_3"
        String outputBed = basename(inputBed, "\.bed") + ".complement.bed"
    }

    # Use a fasta index file to get the genome sizes. And convert that to the
    # bedtools specific "genome" format.
    command {
        set -e
        cut -f1,2 ~{faidx} > sizes.genome
        bedtools complement \
        -g sizes.genome \
        -i ~{inputBed} \
        > ~{outputBed}
    }

    output {
        File complementBed = outputBed
    }

    runtime {
        docker: dockerImage
    }

    parameter_meta {
        faidx: {description: "The fasta index (.fai) file from which to extract the genome sizes",
                category: "required"}
        inputBed: {description: "The inputBed to complement",
                category: "required"}
        outputBed: {description: "The path to write the output to",
                     category: "advanced"}
        dockerImage: {
            description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.",
            category: "advanced"
        }
    }
}

task Merge {
    input {
        File inputBed
        String outputBed = "merged.bed"
        String dockerImage = "quay.io/biocontainers/bedtools:2.23.0--hdbcaa40_3"
    }

    command {
        bedtools merge -i ~{inputBed} > ~{outputBed}
    }

    output {
        File mergedBed = outputBed
    }

    runtime {
        docker: dockerImage
    }

    parameter_meta {
        inputBed: {description: "The bed to merge",
                category: "required"}
        outputBed: {description: "The path to write the output to",
                     category: "advanced"}
        dockerImage: {
            description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.",
            category: "advanced"
        }
    }
}

# Use cat, bedtools sort and bedtools merge to merge bedfiles in a single task.
task MergeBedFiles {
    input {
        Array[File] bedFiles
        String outputBed = "merged.bed"
        String dockerImage = "quay.io/biocontainers/bedtools:2.23.0--hdbcaa40_3"
    }

    # A sorted bed is needed for bedtools merge
    command {
        cat ~{sep=" " bedFiles} | bedtools sort | bedtools merge > ~{outputBed}
    }

    output {
        File mergedBed = outputBed
    }

    runtime {
        docker: dockerImage
    }
    parameter_meta {
        bedFiles: {description: "The bed files to merge",
                category: "required"}
        outputBed: {description: "The path to write the output to",
                     category: "advanced"}
        dockerImage: {
            description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.",
            category: "advanced"
        }
    }
}

task Sort {
    input {
        File inputBed
        Boolean sizeA = false
        Boolean sizeD = false
        Boolean chrThenSizeA = false
        Boolean chrThenSizeD = false
        Boolean chrThenScoreA = false
        Boolean chrThenScoreD = false
        File? genome
        File? faidx
        String outputBed = "output.sorted.bed"
        String dockerImage = "quay.io/biocontainers/bedtools:2.23.0--hdbcaa40_3"
    }

    command {
        set -e
        mkdir -p "$(dirname ~{outputBed})"
        bedtools sort \
        -i ~{inputBed} \
        ~{true="-sizeA" false="" sizeA} \
        ~{true="-sizeD" false="" sizeD} \
        ~{true="-chrThenSizeA" false="" chrThenSizeA} \
        ~{true="-chrThenSizeD" false="" chrThenSizeD} \
        ~{true="-chrThenScoreA" false="" chrThenScoreA} \
        ~{true="-chrThenScoreD" false="" chrThenScoreD} \
        ~{"-g " + genome} \
        ~{"-faidx" + faidx} \
        > ~{outputBed}
    }

    output {
        File sortedBed = outputBed
    }

    runtime {
        docker: dockerImage
    }
}
