#!/bin/bash
#SBATCH -t 200:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --partition standard

source ~/.bashrc
mamba activate snakemake-8.20.3

snakemake --unlock
snakemake --executor slurm --default-resources slurm_account=nefsc slurm_partition=standard --jobs 10 --use-conda

