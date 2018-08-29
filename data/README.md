# Data Input Folders

> What will I find here?

Each data folder here is associated with an experiment, typically with an identifier
that can be found in the [ENCODE experiments portal](https://www.encodeproject.org/experiments/).
The exception is any test folder, for example [TEST-YEAST](TEST-YEAST) provides the same inputs and
metadata files **along** with the actual data (so you can do the getting started tutorial
without needing to download anything). 

Here we will quickly review the files that you will find in these folders:

 - **<folder name>** is typically describing the encode identifier to get more information (and download links) for the data
 - **inputs.json** describes the input paths to the various included files
 - **metadata.csv**: is a comma separated values file for metadata for the pipeline

In the case of the testing data, the files described in the `inputs.json` are also provided.
