#!/bin/bash
#SBATCH --job-name=fastp_array
#SBATCH -c 1
#SBATCH -t 1-0:0:0
#SBATCH --mem=10G
#SBATCH -p medmem
#SBATCH -o %x_%A_%a.out
#SBATCH -e %x_%A_%a.err
#SBATCH --array=[0-12]%13

READS=../Snakemake_Vs_Nextflow/00_reads
OUTDIR=Array_fastp
mkdir -p $OUTDIR

module load bio/fastp/0.23.2

#Create Array

FILES=$(find $READS/*_R1.fastq.gz -type f -exec basename {} _R1.fastq.gz \; )
FILES_ARRAY=(${FILES})

SAMPLE=${FILES_ARRAY[${SLURM_ARRAY_TASK_ID}]}

#### Alternatively, you could assign the files to variables with a text file of sample names:

# Create before running script and comment out, so that each job doesn't overwrite the file
# code to generate text file:
# find $READS/*_R1.fastq.gz -type f -exec basename {} _R1.fastq.gz \; > Array_samplenames.txt

# Uncomment for array if choosing this method:

#SAMPLES=Array_samplenames.txt

#NUM=$(expr ${SLURM_ARRAY_TASK_ID} + 1)

#SAMPLE=$(sed -n ${NUM}p $SAMPLES)

echo $SAMPLE
hostname
echo "JobID: $SLURM_JOB_ID TaskID: $SLURM_ARRAY_TASK_ID" 

fastp \
	--in1 $READS/${SAMPLE}_R1.fastq.gz \
	--in2 $READS/${SAMPLE}_R2.fastq.gz \
	--out1 $OUTDIR/${SAMPLE}_R1_trimmed.fastq.gz \
	--out2 $OUTDIR/${SAMPLE}_R2_trimmed.fastq.gz \
        --json $OUTDIR/${SAMPLE}_fastp.json \
        --html $OUTDIR//${SAMPLE}_fastp.html	
