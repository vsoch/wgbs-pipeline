---
title: Setup
sidebar: main_sidebar
permalink: setup
folder: docs
toc: false
---

## 1. Docker

If you aren't familiar with Docker, it's a container technology that will let us easily use entire packaged software. You should set up and install Docker [per the instructions here](https://docs.docker.com/install/). Make sure that you are able to run the "hello-world" example _without needing superuser priviledges_ before you continue this tutorial.

## 2. Cromwell

[Cromwell](http://cromwell.readthedocs.io/en/stable/tutorials/FiveMinuteIntro/) is a workflow management tool developed by the Broad Institute that we will be using to interact with the pipelines. It's a Java program, so the executable that you will interact with is a ".jar" file. While they have a Docker container ([https://hub.docker.com/r/broadinstitute/cromwell/](https://hub.docker.com/r/broadinstitute/cromwell/)), there are several issues with getting it to run from within Docker because it needs to launch other containers, and so we will use the java file locally. To get you started, we will just show you the executable that you can use locally.

See [here](https://github.com/broadinstitute/cromwell/releases) for the latest release.

```bash
$ wget https://github.com/broadinstitute/cromwell/releases/download/34/cromwell-34.jar
```

Interact with the executable like this:

```bash
$ java -jar cromwell-34.jar
Usage: java -jar /path/to/cromwell.jar [server|run|submit] [options] <args>...

  --help                   Cromwell - Workflow Execution Engine
  --version                
Command: server
Starts a web server on port 8000.  See the web server documentation for more details about the API endpoints.
Command: run [options] workflow-source
Run the workflow and print out the outputs in JSON format.
  workflow-source          Workflow source file.
  --workflow-root <value>  Workflow root.
  -i, --inputs <value>     Workflow inputs file.
  -o, --options <value>    Workflow options file.
  -t, --type <value>       Workflow type.
  -v, --type-version <value>
                           Workflow type version.
  -l, --labels <value>     Workflow labels file.
  -p, --imports <value>    A directory or zipfile to search for workflow imports.
  -m, --metadata-output <value>
                           An optional directory path to output metadata.
Command: submit [options] workflow-source
Submit the workflow to a Cromwell server.
  workflow-source          Workflow source file.
  --workflow-root <value>  Workflow root.
  -i, --inputs <value>     Workflow inputs file.
  -o, --options <value>    Workflow options file.
  -t, --type <value>       Workflow type.
  -v, --type-version <value>
                           Workflow type version.
  -l, --labels <value>     Workflow labels file.
  -p, --imports <value>    A directory or zipfile to search for workflow imports.
  -h, --host <value>       Cromwell server URL.
```

That's all you need to get started! Let's now go back to the [Pipelines section]({{ site.repo }}/#pipelines) where you can choose a pipeline you want to run.
