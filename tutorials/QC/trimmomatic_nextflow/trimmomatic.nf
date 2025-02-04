#!/usr/bin/env nextflow

params.input_dir = null
params.outdir = null
params.adapter_file = null  


if (!params.input_dir) {
    error "Specify input directories with --input_dir '/path/to/dir1,/path/to/dir2'"
}

if (!params.outdir) {
    error "Specify output directory with --outdir"
}

if (!params.adapter_file) {
    error "Specify adapter file with --adapter_file"
}

// Verify input directories exist
params.input_dir.split(',').each { dir ->
    if (!file(dir.trim()).exists()) {
        error "Input directory '${dir.trim()}' does not exist"
    }
}

process trimmomatic  {
    publishDir "${params.outdir}/${dir_name}", mode: 'move', pattern: '*.fq.gz'

    input:
        tuple val(dir_name), val(sample_id), path(read1), path(read2)
        path adapter_file

    output:
        tuple val(dir_name), val(sample_id), 
              path("${sample_id}_paired.R1.fq.gz"), 
              path("${sample_id}_paired.R2.fq.gz"),
              path("${sample_id}_unpaired.R1.fq.gz"),
              path("${sample_id}_unpaired.R2.fq.gz"), emit: trimmed_reads
    
    script:
    """
    module load bio/trimmomatic/0.39

    java -jar /opt/bioinformatics/bio/trimmomatic/trimmomatic-0.39/trimmomatic-0.39.jar PE \
        -threads ${task.cpus} \
        -phred33 \
        ${read1} \
        ${read2} \
        ${sample_id}_paired.R1.fq.gz \
        ${sample_id}_unpaired.R1.fq.gz \
        ${sample_id}_paired.R2.fq.gz \
        ${sample_id}_unpaired.R2.fq.gz \
        ILLUMINACLIP:${adapter_file}:2:30:10:8:TRUE \
        SLIDINGWINDOW:5:15 \
        MINLEN:40

    """
}

workflow {
    adapter_file = file(params.adapter_file)
    if( !adapter_file.exists() ) {
        error "Adapter file ${params.adapter_file} not found"
    }
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

    trimmomatic(reads_ch, adapter_file)
}
