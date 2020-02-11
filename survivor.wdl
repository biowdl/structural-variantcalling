version 1.0

import "common.wdl"

task Merge {
    input{
        String dockerImage = "quay.io/biocontainers/survivor:1.0.6--h6bb024c_0"
        Array[File] filePaths
        Int breakpointDistance = 1000
        Int suppVecs = 2
        Int svType = 1
        Int strandType = 1
        Int distanceBySvSize = 0
        Int minSize = 30
        String sample
        String outputPath
        String memory = "128G"
    }

    command { 
        set -e
        mkdir -p "$(dirname ~{outputPath})"
        echo '~{sep="\n" filePaths}' > fileList
        SURVIVOR merge \
        fileList \
        ~{breakpointDistance} \
        ~{suppVecs} \
        ~{svType} \
        ~{strandType} \
        ~{distanceBySvSize} \
        ~{minSize} \
        ~{outputPath}
    } 

    output {
        File mergedVcf = outputPath
    }
    
    runtime {
        docker: dockerImage
        memory: memory
    }

    parameter_meta {
        filePaths: {description: "An array of VCF files (predictions) to be merged by SURVIVOR", category: "required"}
        sample: {description: "The name of the sample", category: "required"}
        outputPath: {description: "The location the output VCF file should be written.", category: "common"}
        dockerImage: {description: "The docker image used for this task. Changing this may result in errors which the developers may choose not to address.",
                      category: "advanced"}
        minSize: {description: "The mimimum size of SV to be merged", category: "required"}
        distanceBySvSize: {description: "A boolean to predict the pairwise distance between the SVs based on their size", category: "required"}
        strandType: {description: "A boolean to include strand type of an SV to be merged", category: "required"}
        svType: {description: "A boolean to include the type SV to be merged", category: "required"}
        suppVecs: {description: "The minimum number of SV callers to support the merging", category: "required"}
        breakpointDistance: {description: "The distance between pairwise breakpoints between SVs", category: "required"}
        memory: {description: "The memory required to run the programs", category: "common"}
    }
}