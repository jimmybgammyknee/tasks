
task mk_bwameth_index {
    File bwameth
    File genome_fasta

    command {
        ${bwameth} index ${genome_fasta}
    }

    output {
        File out_amb = "${genome_fasta}.bwameth.c2t.amb"
        File out_ann = "${genome_fasta}.bwameth.c2t.ann"
        File out_bwt = "${genome_fasta}.bwameth.c2t.bwt"
        File out_pac = "${genome_fasta}.bwameth.c2t.pac"
        File out_sa = "${genome_fasta}.bwameth.c2t.sa"
    }

    runtime {
        cpu: cpu
    }
}

task bwameth_run {
    File bwameth
    File samtools
    File genome_fasta
    File in_fastqR1
    File in_fastqR2
    String sample_name
    String Reference
    Int cpu=16

    command {
        bwameth.py --threads ${cpu} \
            --reference ${Reference} \
            ${in_fastqR1} ${in_fastqR2} | \
                ${samtools} view -bS - > ${sample_name}.bwameth.bam
    }

    output {
        File out_bam = "${sample_name}.bwameth.bam"
    }

    runtime {
        cpu: cpu
    }
}
