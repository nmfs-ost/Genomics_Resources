#!/usr/bin/env nextflow

params.input_dir = null
params.outdir = null

if (!params.input_dir) {
    error "Specify input directories with --input_dir '/path/to/dir1,/path/to/dir2'"
}

if (!params.outdir) {
    error "Specify output directory with --outdir"
}

// Verify input directories exist
params.input_dir.split(',').each { dir ->
    if (!file(dir.trim()).exists()) {
        error "Input directory '${dir.trim()}' does not exist"
    }
}

process fastp {
    debug true  // Add this line
    publishDir "${params.outdir}/${dir_name}", mode: 'move', pattern: '*.clip.fastq.gz'
    tag "${dir_name}/${sample_id}"
    cpus 4

    input:
        tuple val(dir_name), val(sample_id), path(read1), path(read2)

    output:
        tuple val(dir_name), val(sample_id),
              path("${sample_id}.R1.clip.fastq.gz"),
              path("${sample_id}.R2.clip.fastq.gz"), emit: trimmed_reads

    script:
    """
    module load bio/fastp/0.23.2

    fastp -i ${read1} \
          -I ${read2} \
          -o ${sample_id}.R1.clip.fastq.gz \
          -O ${sample_id}.R2.clip.fastq.gz \
          -w ${task.cpus} \
          --cut_right \
          -l 35 \
          -h /dev/null \
          -j /dev/null \
          --dont_eval_duplication
    """
}

workflow {
        reads_ch = Channel
        .fromFilePairs(params.input_dir.split(',').collect { dir ->
            file(dir.trim()) + "/*_R{1,2}_001.fastq.gz"
     }, flat: true)
        .map { sample_id, read1, read2 ->
            def dir_name = read1.parent.name
            tuple(dir_name, sample_id, read1, read2)
        }

    reads_ch.view { dir_name, sample_id, read1, read2 ->
        "Dir: $dir_name, Sample: $sample_id\nR1: $read1\nR2: $read2\n"
    }

    fastp(reads_ch)
}
