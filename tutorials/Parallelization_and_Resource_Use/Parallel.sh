#!/bin/bash
#SBATCH --job-name=fastp_trim
#SBATCH -c 10
#SBATCH --mem=100G
#SBATCH --partition=medmem
#SBATCH -t 1-0:0:0
#SBATCH -o %x_%j.out
#SBATCH -e %x_%j.err

# written by Mia Nahom


READS=../Snakemake_Vs_Nextflow/00_reads
OUTDIR=Parallel_fastp
mkdir -p $OUTDIR

find $READS/*_R1.fastq.gz -type f -exec basename {} _R1.fastq.gz \; > Parallel_samplenames.txt

module load bio/fastp/0.23.2

cat Parallel_samplenames.txt | parallel -j 10 \
	fastp \
	--in1 $READS/{}_R1.fastq.gz \
	--in2 $READS/{}_R2.fastq.gz \
	--out1 $OUTDIR/{}_R1_trimmed.fastq.gz \
	--out2 $OUTDIR/{}_R2_trimmed.fastq.gz \
        --json $OUTDIR/{}_fastp.json \
        --html $OUTDIR/{}_fastp.html
