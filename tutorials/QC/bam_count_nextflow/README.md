# Calculate bam stats with nextflow

 Author infomation
- Reid Brennan
- Email: reid.brennan@noaa.gov
- Last update: 2025-02-14

---

This pipeline processes BAM files to generate alignment statistics including:
- Total reads
- Mapped reads and percentage
- Duplicate reads and percentage
- High-quality mapped reads (Q20) and percentage


The pipeline generates a CSV file with the following columns:

- sample: Sample name derived from BAM filename
- total_reads: Total number of reads
- total_mapped: Number of mapped reads
- map_percent: Percentage of mapped reads
- duplicates: Number of duplicate reads
- dup_percent: Percentage of duplicate reads
- mapped_q20: Number of mapped reads with mapping quality ≥20
- map_percent_q20: Percentage of Q20 mapped reads


## To run

Assuming you're using sedna, to run, start a new screen or tmux (very important). Then run the command below:


```bash

mamba activate nextflow-24.04.4

nextflow run count_bams.nf \
    --input_dir path/to/your/bam/files \
    --output_dir path/to/output \
    --output_file counts.csv

```

where:
- `count_bams.nf` is the nextflow script that runs the alignment stats.  
- ` --input_dir` is the path to your bam files
- `--output_dir` is the output location for the txt file
- `output_file` is the name of the output file, which will be csv
