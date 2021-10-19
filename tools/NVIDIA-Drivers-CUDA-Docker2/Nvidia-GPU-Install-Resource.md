# NVIDIA GPU Install / Setup Resources:

1. [NVIDIA/nvidia-docker - Installation](https://github.com/NVIDIA/nvidia-docker/wiki/Installation-(Native-GPU-Support)#usage)

# Installation (Native GPU Support)
Kevin Klues edited this page on Aug 3, 2020 · 2 revisions
Prerequisites
The list of prerequisites for running the NVIDIA runtime is described below.
For information on how to install Docker for your Linux distribution, please refer to the [Docker documentation](https://docs.docker.com/engine/installation).

# GNU/Linux x86_64 with kernel version > 3.10
Docker >= 19.03
NVIDIA GPU with Architecture > Fermi (2.1)
[NVIDIA drivers](http://www.nvidia.com/object/unix.html) ~= 361.93 (untested on older versions)
Your driver version might limit your CUDA capabilities (see [CUDA requirements](https://github.com/NVIDIA/nvidia-docker/wiki/CUDA#requirements))

# Installing GPU Support
Make sure you have installed the [NVIDIA driver](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#how-do-i-install-the-nvidia-driver) and a [supported version](https://github.com/NVIDIA/nvidia-docker/wiki/Frequently-Asked-Questions#which-docker-packages-are-supported) of [Docker](https://docs.docker.com/engine/installation/) for your distribution (see prerequisites).

Install the repository for your distribution by following the instructions [here](http://nvidia.github.io/nvidia-docker/).
Install the nvidia-container-toolkit package:
$ sudo apt-get install -y nvidia-container-toolkit
$ sudo yum install -y nvidia-container-toolkit
# Usage
The NVIDIA runtime is integrated with the Docker CLI and GPUs can be accessed seamlessly by the container via the Docker CLI options. Some examples are shown below.
```
# Starting a GPU enabled container
$ docker run --gpus all nvidia/cuda nvidia-smi

# Start a GPU enabled container on two GPUs
$ docker run --gpus 2 nvidia/cuda nvidia-smi

# Starting a GPU enabled container on specific GPUs
$ docker run --gpus device=1,2 nvidia/cuda nvidia-smi
$ docker run --gpus device=UUID-ABCDEF,1 nvidia/cuda nvidia-smi

# Specifying a capability (graphics, compute, ...) for my container
# Note this is rarely if ever used this way
$ docker run --gpus all,capabilities=utilities nvidia/cuda nvidia-smi
# Non-CUDA image
Setting NVIDIA_VISIBLE_DEVICES will enable GPU support for any container image:

docker run --gpus all,capabilities=utilities --rm debian:stretch nvidia-smi
```

# Dockerfiles
If the environment variables are set inside the Dockerfile, you don't need to set them on the docker run command-line.

For instance, if you are creating your own custom CUDA container, you should use the following:

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
These environment variables are already set in our official images pushed to [Docker Hub](https://gitlab.com/nvidia/container-images/cuda/blob/master/dist/11.0/ubuntu20.04-x86_64/base/Dockerfile#L27-29).

For a Dockerfile using the NVIDIA Video Codec SDK, you should use:

ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,video,utility
