
task Mkref {
    # From HumanCellAtlas
    # use kallisto index to generate the kallisto index for use with other functions in this
    # module

    File kallisto
    File transcriptome_fasta  # fasta file containing transcripts ONLY (NOT a full genome!)
    Int k  # size of kmer in index; must be an odd number.

    command {
        ${kallisto} index \
            --index kallisto.idx \
            -k ${k} \
            "${transcriptome_fasta}"
    }

    runtime {
        cpu: cpu
    }

    output {
        File index = "kallisto.idx"
    }
}

task rnaseq_kallisto {
    File kallisto
    File trim_fastqR1
    File trim_fastqR2
    File index
    String sample_name
    Int cpu=4

    command {
    ${kallisto} quant \
      --index "${index}" \
      --output-dir . \
      --bootstrap-samples 100 \
      --threads ${cpu} \
      ${trim_fastqR1} ${trim_fastqR2}
    mv abundance.h5 "${sample_name}.abundance.h5"
    mv abundance.tsv "${sample_name}.abundance.tsv"
    mv run_info.json "${sample_name}.run_info.json"
    }

    runtime {
      cpu: cpu
    }

    output {
        File abundance_h5 = "${sample_name}.abundance.h5"
        File abundance_tsv = "${sample_name}.abundance.tsv"
        File log = "${sample_name}.run_info.json"
    }
}
