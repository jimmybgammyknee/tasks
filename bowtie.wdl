task Bowtie {
    String reference
    File read1
    File? read2
    String outputPath
    String? precommand
    Int? threads = 1

    command {
        set -eo pipefail
        mkdir -p $(dirname ${outputPath})
        ${precommand}
        bowtie --sam \
        ${"--threads " + threads} \
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