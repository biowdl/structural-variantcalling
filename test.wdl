version 1.0

workflow testing{
    input {
        File bam
        File bai
        File reference
        File iReference
    }
    call caller{
        input:
            bam = bam,
            reference = reference,
            iReference = iReference,
            bai = bai
    }
}

task caller {
    input{
        File bam
        File reference
        File iReference
        File bai
    }

    command <<<
       clever ~{bam} ~{reference} test.vcf
       #lumpyexpress -B ~{bam} -o fullBam.bam.vcf
       #delly call -g ~{reference} -o s1.bcf ~{bai}

    >>>

    runtime {
        #docker: "quay.io/biocontainers/delly:0.8.1--h4037b6b_1"
        #docker: "quay.io/biocontainers/lumpy-sv:0.2.14a--hdfb72b2_2"
        docker: "quay.io/biocontainers/clever-toolkit:2.3--py35_boost1.64_0"
    }
}