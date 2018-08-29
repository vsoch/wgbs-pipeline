Bootstrap: docker
From: ubuntu:16.04

# sudo singularity build gemBS.simg Singularity

%labels
    maintainer @vsoch

%setup
    mkdir -p ${SINGULARITY_ROOTFS}/software
    cp -R helpers ${SINGULARITY_ROOTFS}/software

%environment
    DEBIAN_FRONTEND=noninteractive
    PATH="/software:${PATH}"
    PATH="/root/.local/bin:${PATH}"
    PATH="/software/helpers:${PATH}"
    export PATH DEBIAN_FRONTEND

%post
    export DEBIAN_FRONTEND=noninteractive

    apt-get update && apt-get install -y \
	python3 \
	build-essential \
	git \
	python3-pip \
	wget \
	pigz \
	zlib1g-dev \
	libbz2-dev \
	gsl-bin \
	libgsl0-dev \
	libncurses5-dev \
	liblzma-dev \
	libssl-dev \
	libcurl4-openssl-dev

    pip3 install matplotlib multiprocess

    # Make directory for all softwares
    mkdir -p /software
    cd /software
    export PATH="/software:${PATH}"

    # Install gemBS
    git clone --recursive https://github.com/heathsc/gemBS.git
    cd gemBS && python3 setup.py install --user
    export PATH="/root/.local/bin:${PATH}"

    # Set up Python helpers for WDL scripts
    cd /software/helpers
    chmod +x -R /software/helpers/ 
    export PATH="/software/helpers:${PATH}"

%runscript
    exec /bin/bash -c "$@"
