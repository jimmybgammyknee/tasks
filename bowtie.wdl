task Bowtie {
    File reference
    File read1
    File? read2
    String outputPath
    String? precommand
    Int? threads = 1

    command {
        ## https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
        set -eo pipefail

        mkdir -p $(dirname ${outputPath})

        ${precommand}
        bowtie \
        ${"--threads" + threads} \
        ${reference} \
        ${true="-1 " false="" defined(read2)} ${read1} \
        ${"-2 " + read2} | \
        samtools view -Sbh - | \
        samtools sort -o ${outputPath}
    }

    output {
        File bamFile = outputPath
    }

    runtime {
        cpu: threads
    }
}