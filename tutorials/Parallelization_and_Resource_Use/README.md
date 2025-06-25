This repo demonstrate how to parallelize jobs, particularly focused on SEDNA. 

For many analyses, we can submit a bunch of different jobs to run in parallel, rather than either sequentially (i.e., in a loop) or as a single large job. This generally makes jobs much faster and more efficient and is the preferred way of doing analysis.

Examples of analyses where you might parallelize might be:

- Bootstrapped phylogenetics
- Phylogenetic gene tree inference
- BLAST
- Trimming and mapping reads
- Replicate MCMCs
- Sliding genomic window analyses
- Genome repeat masking

### HPC architecture

 Computers, even your personal computer, are made up of processors with multiple cores (or CPUs). Each core can run an independent job. Most personal laptops have ~4-10 cores (or even more), which means they could run this many different "jobs" in parallel.
 
 You can run jobs in parallel on your own computer, but HPCs are where parallelization really shines. 

 HPCs generally consist of a headnode, compute nodes, and storage. The head node is where you login, the storage is where you keep your data, and the compute nodes are where the work takes place. Each compute node consists of multiple processors, each of which consists of multiple CPUs/cores. HPCs typically have hundreds or thousands of cores available across multiple nodes, allowing you to scale your analysis from running a few jobs simultaneously to potentially hundreds at once. 
 This  parallelization can reduce analysis time.

<img src="images/HPC_architecture.png" width="800" />


### Examples of parallelization

Building on our last tutorial [comparing snakemake and nextflow](https://github.com/nmfs-ost/Genomics_Resources/tree/main/tutorials/Snakemake_Vs_Nextflow), we will show how to run [fastp](https://github.com/OpenGene/fastp) in parallel using:

- nextflow
- snakemake
- parallel
- array (in slurm)

Note that all of these scripts are setup to work on SEDNA, but could be transported to another cluster or your computer with some adjustments.

#### responsible resource use

A key part of these analyses (and any analysis) is determining

1. How many resources are available.
2. How many resources you need
3. Fitting 1 and 2 together in a logical way.

For example, if you're on a clould instance (aws, azure, etc) and request way more CPUs than you can use, you're wasting money. Similarly, if you're on SEDNA or an HPC, occupying a bunch of resoureces will keep anyone else from using them. Some HPCs deal with this automatically (at least how much of the cluster you're requesting at one time). Others, like SEDNA, do not. This is by design so you could use all of SEDNA, say if you're working the in the middle of the night and no one else needs the resources. But typically you want to leave resources for others. 

##### So how many resources do I need?

This is actually kind of hard to answer. Once you run some jobs, you can directly ask how much memory it used, for example using `seff <jobid>` on Slurm. Then next time you run a job, you can adjust (or submit one job as a test before running a batch). 

#### GNU parallel

[GNU parallel](https://www.gnu.org/software/parallel/) allows you to execute multiple jobs simultaneously on a single machine, which can be useful on your own computer or under certain circumstances on an HPC. Note that this is the least parallelizeable approach as you're limited by the direct resources that you request! So they all need to be allocated at once before the job runs. This is different from the other approaches, which submit and run jobs independently. 

In this approach, we're feeding parallel some list and telling it to execute the same job on everything in that list. Basically, we're filling in the blanks in the brackets below from the list:

<img src="images/gnu_parallel.png" width="800" />


[See the full script here](https://github.com/nmfs-ost/Genomics_Resources/blob/main/tutorials/Parallelization_and_Resource_Use/Parallel.sh)

#### array jobs

add some details here. 

[See the full script here](https://github.com/nmfs-ost/Genomics_Resources/blob/main/tutorials/Parallelization_and_Resource_Use/Parallel.sh)

<img src="images/arrays.png" width="800" />

#### snakemake

See the [comparing snakemake and nextflow](https://github.com/nmfs-ost/Genomics_Resources/tree/main/tutorials/Snakemake_Vs_Nextflow) tutorial for how to run this in full. 

<img src="images/snakemake.png" width="800" />

#### nextflow

See the [comparing snakemake and nextflow](https://github.com/nmfs-ost/Genomics_Resources/tree/main/tutorials/Snakemake_Vs_Nextflow) tutorial for how to run this in full. 

<img src="images/nextflow.png" width="800" />





 

 
