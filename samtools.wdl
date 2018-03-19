task Sort {
    String? precommand
    File unsortedBam


}


task SamToBam {
    String? preCommand
    File samFile
    String bamFilePath

    command{
        set -eo pipefail
        ${preCommand}
        samtools view -Sbh ${samFile} > ${bamFilePath}
    }
    output {
        File outputBam = bamFilePath
    }
}

task Index {
    String? preCommand
    String bamFilePath

    command {
        set -e -o pipefail
        ${preCommand}
        samtools index ${bamFilePath}
    }

    output {
        File indexFile = bamFilePath + ".bai"
    }
}

task Merge {
    String? preCommand
    Array[File]+ bamFiles
    String outputBamPath

    command {
        set -e -o pipefail
        ${preCommand}
        samtools merge ${outputBamPath} ${sep=' ' bamFiles}
    }

    output {
        File outputBam = outputBamPath
    }
}

task Markdup {
    String? preCommand
    File inputBam
    String outputBamPath

    command {
        set -e -o pipefail
        ${preCommand}
        samtools markdup ${inputBam} ${outputBamPath}
    }

    output {
        File outputBam = outputBamPath
    }
}

task Flagstat {
    String? preCommand
    File inputBam
    String outputPath

    command {
        set -e -o pipefail
        ${preCommand}
        samtools flagstat ${inputBam} > ${outputPath}
    }

    output {
        File flagstat = outputPath
    }
}
