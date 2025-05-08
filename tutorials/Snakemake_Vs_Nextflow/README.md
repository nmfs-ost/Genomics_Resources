This repo is designed to compare a simple workflow
between snakemake and nextflow.

First, download and move into the GitHub repository.

```
git clone https://github.com/ccpowers-NOAA/PEMAD-PBB-fastp.git
cd PEMAD-PBB-fastp
```

The raw data are downloaded as part of the repository (`00_reads`).

## Snakemake 

To run snakemake, first setup your snakemake
conda environment

`mamba env create -f envs/snakemake-8.20.3.yaml -n snakemake-8.20.3`

and install the following dependency

`pip install snakemake-executor-plugin-slurm --user`

Execute the pipeline interactively by running
```
mamba activate snakemake-8.20.3.yaml
snakemake -j1 --use-conda
```

or in the queue by running

`sbatch snake_manager.sh`

## Nextflow

To run nextflow, we can use SEDNA's nextflow
conda environment

`mamba activate nextflow-24.04.4`

Execute the pipeline interactively by running

`nextflow -c nf.config.NOAA_SEDNA run main.nf -entry QC`

or in the queue by running

`sbatch nextflow_job.sh`
