# trimmomatic and nextflow

 Author infomation
- Reid Brennan
- Email: reid.brennan@noaa.gov
- Last update: 2025-01-30

---

This script will run in [trimmomatic](http://www.usadellab.org/cms/?page=trimmomatic), submitting submitting 20 jobs at a time via slurm, each using 8 cpus. These can be edited in `nextflow.config`. It currently works for paired end reads. It could be modified for single end without a ton of trouble. It accepts multiple input directories and will output trimmed files, keeping directories separate.

You should put the `trimmomati.nf`, `nextflow.config`, and `NexteraPE_NT.fa` in your working directory. The nf file can be in scripts and you can point to it from there. It is best to have the config file where you will run things from.

**IMPORTANT**: The naming of the reads matters. They're currently set to be `SAMPLEID_R1_001.fastq.gz` and `SAMPLEID_R2_001.fastq.gz`. It will not work if there is any other structure. This could be modified in line 67 of trimmomatic.nf.


The trimmomatic command in the script is:

```bash
    module load bio/trimmomatic/0.39

    java -jar /opt/bioinformatics/bio/trimmomatic/trimmomatic-0.39/trimmomatic-0.39.jar PE \
        -threads ${task.cpus} \
        ${read1} \
        ${read2} \
        ${sample_id}_paired.R1.fq.gz \
        ${sample_id}_unpaired.R1.fq.gz \
        ${sample_id}_paired.R2.fq.gz \
        ${sample_id}_unpaired.R2.fq.gz \
        ILLUMINACLIP:${adapter_file}:2:30:10:8:TRUE \
        SLIDINGWINDOW:5:15 \
        MINLEN:40

```

You can edit as you see fit, just as you would a normal shell script. Note that changing it to single end without altering the rest of the script will probably break things. You can ask me to help do this is you want.


## To run

Assuming you're using sedna, to run, start a new screen or tmux (very important). Then run the command below:

```bash
mamba activate nextflow-24.04.4

nextflow run trimmomatic.nf \
  --input_dir '241129_NOA015_PanTrop_WGS,241129_NOA016_PanTrop_WGS' \
  --outdir trimmed_trimmomatic \
  --adapter_file NexteraPE_NT.fa -profile trimmomatic

```

Then disconnect from your screen. 

where:
- `trimmomatic.nf` is the nextflow script that runs trimmomatic.  
- ` --input_dir '241129_NOA015_PanTrop_WGS,241129_NOA016_PanTrop_WGS'` are your input directories, comma separated.
- `--outdir trimmed` is the output location. It will automatically make this directory and subdirectories with the same name as your input directories.
- `-profile trimmomatic` is what is feeding the slurm option and things specific to this job. 

Afterwards, run fastqc to make sure things ran correctly. You can track the overall progress from the screen. 


## nf tower

If you want, you can track your run with nextflow tower. To do this, make an account on [seqera](https://cloud.seqera.io/). Then generate an access token ([instructions here](https://docs.seqera.io/platform/23.1/getting-started/usage)). Add this token to the `nextflow.config` file on line 4. 

Then you can run your job with the same command as above, but adding `-with-tower`. For example:

```bash
mamba activate nextflow-24.04.4

nextflow run trimmomatic.nf \
  --input_dir '241129_NOA015_PanTrop_WGS,241129_NOA016_PanTrop_WGS' \
  --outdir trimmed_trimmomatic \
  --adapter_file NexteraPE_NT.fa -profile trimmomatic \
  -with-tower

```

And you can monitor it at https://tower.nf/ under `runs`.


## other info

I'm currently "moving" files from the work directory to the specified output. This is just for simplicity for new users and space saving, as we're somewhat limited. It also makes the resume option not really work. This could be changed easily so runs could be resumed if they break.

Starting memory is 4gb and time is 60min... this time is likely overkill if you have small files and you can adjust in the config file. Note that if anything times out or errors due to memory (or any error actually), it will resubmit that job two more times, increasing the memory and time with each attempt, proportional to the attempt (*2 and *3).
