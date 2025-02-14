#!/usr/bin/env nextflow

// Define input parameters
params.input_dir = null
params.output_file = null
params.output_dir = null

// Define the process to calculate alignment statistics
process BAMSTATS {
    input:
    file bam

    output:
    stdout

    script:
    """
    module load bio/samtools/1.19

    samtools flagstat ${bam} > tmp.${bam.baseName}.txt

    TOTAL=\$(grep "in total" tmp.${bam.baseName}.txt | cut -f 1 -d " ")
    MAPPED=\$(grep "mapped (" tmp.${bam.baseName}.txt | cut -f 1 -d " " | head -n 1)
    PERCENT=\$(grep "mapped (" tmp.${bam.baseName}.txt | cut -f 2 -d "(" | cut -f 1 -d "%" | head -n 1)
    MAPPED_q=\$(samtools view -F 4 -q 20 ${bam} | wc -l)
    PERCENT_q=\$(echo "scale=2 ; \$MAPPED_q / \$TOTAL" | bc)
    DUPS=\$(grep "duplicates" tmp.${bam.baseName}.txt | cut -f 1 -d " ")
    DUP_PERCENT=\$(echo "scale=2 ; \$DUPS  / \$TOTAL" | bc)

    echo "${bam.baseName},\$TOTAL,\$MAPPED,\$PERCENT,\$DUPS,\$DUP_PERCENT,\$MAPPED_q,\$PERCENT_q"
    rm tmp.${bam.baseName}.txt

    """
}

workflow {
    // Validate parameters are provided
    if (params.input_dir == null) {
        error "Error: --input_dir parameter is required"
    }
    if (params.output_file == null) {
        error "Error: --output_file parameter is required"
    }
    if (params.output_dir == null) {
        error "Error: --output_dir parameter is required"
    }  
  
  // Validate input directory exists
    def input_dir = file(params.input_dir)
    if (!input_dir.exists()) {
        error "Error: Input directory '${params.input_dir}' does not exist"
    }
    if (!input_dir.isDirectory()) {
        error "Error: '${params.input_dir}' is not a directory"
    }
    
    // Create a channel from input BAM files
    bam_files = Channel.fromPath("${params.input_dir}/*.bam")
    
    println "Input directory: ${params.input_dir}"
    bam_files.count().view { count ->
        println "Number of BAM files found: $count"
    }

    // Run BAMSTATS
    alignment_stats = BAMSTATS(bam_files)

    // Collect and process results
    alignment_stats.collectFile(
        name: "${params.output_dir}/${params.output_file}",
        seed: "sample,total_reads,total_mapped,map_percent,duplicates,dup_percent,mapped_q20,map_percent_q20",
        newLine: false
    )

    println "Output file: ${params.output_file}"
}
