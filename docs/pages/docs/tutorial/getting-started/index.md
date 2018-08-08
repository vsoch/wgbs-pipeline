---
title: Whole Genome 
sidebar: main_sidebar
permalink: getting-started
folder: docs
---

The [wbgs-pipeline]({{ site.github.url }}), meaning "whole genome bisulfites sequencing data," is an infrastructure to run the [gemBS pipeline](https://github.com/heathsc/gemBS) provided by Encode as one of its [pipelines](https://www.encodeproject.org/wgbs/).
What will it do? It will do highthroughput analysis of DNA methylation data from whole genome bisulfites sequencing data (WGBS). 
It uses [GEM3](https://www.biorxiv.org/content/early/2017/10/11/201988), a high performance read aligner and bs_call, and a high performance variant and methyation caller. This tutorial will guide you through doing the following:

 1. Install Dependencies
 2. Understand Data
 3. Run your pipeline
   a. [Singularity Container](#singularity-container)

## Step 1: Install Dependencies

We are going to be using a Dockerized Cromwell. If you haven't already, read about how to set up Docker and Cromwell on our [setup page]({{ site.github.url }}/setup) and then come back here.

## Step 2: Locate Data

The test data for this tutorial is provided with this repository in the "data" folder. In this folder you will find subdirectories, 
each associated with an identifier from the [ENCODE experiments portal](https://www.encodeproject.org/experiments).  Take a look!

```bash
$ tree data/
data/
├── ENCSR750CPN                   (-- experiment identifier in the portal
│   ├── ENCSR750CPN.json
│   └── metadata.csv
├── ENCSR786DCL
│   ├── ENCSR786DCL.json
│   └── metadata.csv
├── fastq                          (-- fastq references
│   ├── flowcell_1_1_1.fastq.gz
│   └── flowcell_1_1_2.fastq.gz
├── README.md
└── TEST-YEAST                    (-- our testing data!
    ├── inputs.json
    ├── metadata.csv
    ├── yeast.BS.gem
    ├── yeast.BS.info
    └── yeast.fa
```

The first two folders are experiment ids. The exception is the `TEST-YEAST` folder, which has made life
easy for you because the actual data files are provided (the last three in the list you would need to download
for an actual experiment from the portal because they are much larger!). For example, the folder `ENCSR750CPN` 
is for [this experiment](https://www.encodeproject.org/experiments/ENCSR750CPN). 

> What is an experiment? 

An experiment is typically a submission of data from
a lab, usually associated with one or more genomic samples from the tissue of one or more species. In this case, it comes from a 51 year old woman, and from the lab of Richard Mayers. It's good to realize that the data you are working with is very valuable, and has had multiple entities (including the donator) put time and energy into providing and preparing it. Do good with it!

## Step 3: Meet the Pipeline

It's time to meet the pipeline! The "wdl" file in the base of the repository is the "widdle file" that describes the steps to this
pipeline. The data that we just looked at above is going to be "plugged in" to this specification to do an analysis! With this understanding, now we can review what we will do today:

 1. Download this repository from Github
 2. Using the software we installed above (Cromwell and Docker) run and control a pipeline **from** our computer
 3. Run the same pipeline on a shared research cluster,
 4. And again on a cloud service


### Clone the Repository

First let's start on your local machine, and clone the repository.

```bash
git clone {{ site.github.repository_url }}
cd {{ site.github.repository_name }}
```
What did we just download? Let's take a look!

```bash
$ tree $PWD -L 1
wgbs-pipeline
├── backends
├── Dockerfile   (-- a recipe to build a Docker container
├── docs         (-- documentation you are reading now, rendered on Github Pages
├── helpers
├── LICENSE
├── README.md
├── Singularity  (-- recipe for building a Singularity container
├── data         (-- data input folders
├── runners      (-- "widdle" file folder with runners for the pipeline
└── workflow_opts
```

 - the workflows are in the `runners` folder. They are files that end in `*.wdl`
 - repository provided data and input specifications, in subfolders corresponding to experiment identifiers, are under `data`
 - `Dockerfile` and `Singularity` are recipes that build containers
 - `backends` and `workflow_opts` and folders for different running configurations (e.g., SLURM vs. Google Cloud)

Most of the above is self explanatory, but actually let's just ignore the chunk of files and tell you the specific files that you should care about:

 - **runners/wgbs-pipeline.wdl** is actually the brain of the real operation. This is a definition of inputs and outputs that is going to be given to Cromwell to run the pipeline. But since we are doing a test tutorial, we are actually going to be interacting with
 - **runners/test.wdl** is a dummy example of the actual pipeline, and it uses data and configurations provided in `data/TEST-YEAST`.
 - **workflow_ops** is where you will find files that define variables for different pipeline runners. For example if you are working on Google Cloud, you might be asked to set preference for a zone. 
 
Let's not worry about the rest for now. You can continue on by selecting the environment where you want to run the pipeline.

## Step 4: Choose Where to Run

Since we are running a dummy test case with rather tiny data, we can start on your local machine.

### Singularity Container

We are going to be interacting with Cromwell locally (the cromwell-34.jar file that you downloaded previously)
and interact with gemBS in a container. Let's build the Singularity container in advance, so it's found in the present working directory. It will build from the `Singularity` file.

```bash
sudo singularity build gemBS.simg Singularity
```

#### Customize Local Variables

Remember the [workflow_opts](workflow_opts) folder you found locally?

```bash
docker.json  google_docker.json singularity.json
```

Guess what file we will be interacting with? Since we are using Singularity, we are going to be using the `singularity.json` file.


```bash
{
    "default_runtime_attributes" : {
        "singularity_container" : "gemBS.simg"
    }
}
```

Note that you can change the `workflow_opts/singularity.json` container file name, it's the variable called `singularity_container`.
It could be a Singularity Hub uri (e.g., `shub://<username>/<reponame>` or another local image name. The container should 
generally (for this repository) have a runscript/entrypoint of executing `/bin/bash -c "$@"` which means that we could take
any argument given to it. You could also use a docker URI (e.g,, `docker://<username>/<reponame>`), and this will pull a Docker image into Singularity (so you might
only need to maintain one).


#### Data Inputs

Today we are going to be working with the testing yeast data, which is located in it's corresponding folder:

```bash
$ tree data/TEST-YEAST/
data/TEST-YEAST/
├── inputs.json
├── metadata.csv
├── yeast.BS.gem
├── yeast.BS.info
└── yeast.fa
```

We can be stupid and quickly see the data that we need by looking at the `inputs.json` file provided:

```bash
{
    "wgbs.prepare.metadata_file": "data/TEST-YEAST/metadata.csv",
    "wgbs.chromosomes":["chrIII"],
    "wgbs.pyglob_nearness":1,
    "wgbs.organism":"Yeast",
    "wgbs.reference": "data/TEST-YEAST/yeast.fa",
    "wgbs.fastqs": [["data/fastq/flowcell_1_1_1.fastq.gz",
                     "data/fastq/flowcell_1_1_2.fastq.gz"]],
    "wgbs.sample_names": ["sample1", "sample2"],
    "wgbs.sample_barcodes": ["YEASTY1", "YEASTY2"]
}
```

Note that if you've run this already and the run generated an indexed reference, you can add that 
to the configuration too (otherwise it is generated again):

```bash
    "wgbs.indexed_reference": "data/TEST-YEAST/yeast.gem",
```

The files for the yeast input (e.g., yeast.fa) are in the same folder as `inputs.json`. Since we are running
the container with the present working directory (with cromwell) at the repository base, this is the relative path
that we assume. We won't go into the structure of this file
in detail, but notice that it has fields for a reference fasta, chromosomes, and things like the organism.
If you are familiar with python, you might guess that `wgbs` is referencing the pipeline name, and will
help to put the loaded data into a namespace for it.

#### Run the Pipeline!

We haven't done anything, and that's because we didn't need to set up a cloud, and we didn't need
to download data. To summarize what we have covered thus far:

 - **backends/backend.conf** is provided in the respository.
 - **cromwell-34.jar** we downloaded from Github as `cromwell-34.jar`
 - **inputs.json** is an input that you select from a data subfolder under `data`
 - **workflow_opts/singularity.json** are workflow arguments for singularity


Easy peezy! Let's run Cromwell!  Tell it to use singularity! First, here is how to do it with an instance (easier to get a PID)

```bash
java -jar -Dconfig.file=backends/backend.conf -Dbackend.default=singularity-instance cromwell-34.jar run runners/test.wdl -i data/TEST-YEAST/inputs.json -o workflow_opts/singularity.json
```

and here is how to do it with just a container (we need to figure out how to get the PID, it's currently a bug):

```bash
$ java -jar -Dconfig.file=backends/backend.conf -Dbackend.default=singularity cromwell-34.jar run runners/test.wdl -i data/TEST-YEAST/inputs.json -o workflow_opts/singularity.json
```

## Debugging

Here are some common errors you might hit. At least I did :)

### Permissions Errors with Singularity

If you cat an error file and see a permission denied:

```bash
$ cat /home/vanessa/Documents/Dropbox/Code/labs/cherry/pipelines/wgbs-pipeline/cromwell-executions/wgbs/55de1d03-9a64-4412-a3cc-14d38dc365ab/call-flatten_/execution/stderr.submit 
/.singularity.d/actions/exec: 9: exec: /home/vanessa/Documents/Dropbox/Code/labs/cherry/pipelines/wgbs-pipeline/cromwell-executions/wgbs/55de1d03-9a64-4412-a3cc-14d38dc365ab/call-flatten_/execution/script: Permission denied
```
It's likely that you were using Docker before, and so the permissions on the `cromwell-executions` directory is root owned, along with the `cromwell-workflow-logs`. You can remove these directories, and try again (or just change ownership to be your user, recursively.)

```bash
sudo chown $USER -R cromwell-executions
# or (who needs old logs anyway...)
sudo rm -rf cromwell-executions
```
