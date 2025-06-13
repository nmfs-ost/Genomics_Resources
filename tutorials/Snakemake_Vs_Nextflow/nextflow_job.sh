#!/bin/bash
#SBATCH -t 200:00:00
#SBATCH --nodes=1 --ntasks-per-node=1
#SBATCH --export=NONE
#SBATCH --partition standard

source ~/.bashrc
mamba activate nextflow-24.04.4

nextflow -c nf.config.NOAA_SEDNA run main.nf -entry QC