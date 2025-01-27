# fastp and nextflow

 Author infomation
- Reid Brennan
- Email: reid.brennan@noaa.gov
- Last update: 2025-01-27


This script will run in parallel, submitting 25 jobs at a time. It currently works for paired end reads. It could be modified for single end without a ton of trouble. 

You should put the `fastp.nf` and the `nextflow.config` in your working directory. the nf file can be in scripts and you can point to it from there. It is best to have the config file where you will run things from.

The fastp command in the script is:

```bash

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
```

You could edit this command directly in the `fastp.nf` script. Some options are interdependent, so I'd suggest only changing the fastp parameters such as `-l`, `--cut_right`, and `--dont_eval_duplication`

### To run:

Assuming you're using Sedna. 

To run, start a new screen (very important; or tmux). Then run the command below:

```bash
mamba activate nextflow-24.04.4

nextflow run fastp.nf --input_dir '241129_NOA015_PanTrop_WGS,241129_NOA016_PanTrop_WGS' --outdir trimmed -profile fastp

```

Then disconnect from your screen. 

where:
- `fastp.nf` is the nextflow script that runs fastp. If it in in `scripts`, use `./scripts/fastp.nf`. 
- ` --input_dir '241129_NOA015_PanTrop_WGS,241129_NOA016_PanTrop_WGS'` are your input directories, comma separated.
- `--outdir trimmed` is the output location. You need to make this initial directory, but then it will automatically make subdirectories with the same name as your input directories.
- `-profile fastp` is what is feeding the slurm option and things specific to this job. 

I'd recommend running fastqc or at least counting reads after to make sure things ran correctly. You can track the overall progress from the screen. 

### things that could be added/changed

- add single end read option
- You can add [nextflow tower](https://cloud.seqera.io/) option, which lets you monitor jobs online (and is pretty nice) by adding `-with-tower` to the nextflow command and the appropriate option in your config file. Ask if you are interested in this.
- I'm currently "moving" files from the work directory to the specified output. This is just for simplicity for new users and space saving. It also makes the `resume` option not really work. This could be changed easily so runs could be resumed if they break.
