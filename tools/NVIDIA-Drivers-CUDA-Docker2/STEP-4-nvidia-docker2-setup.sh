#!/bin/bash -x

# Nvidia Container toolkit
# ref: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker

docker --version

# Add the nvidia-docker package repositories
# Nvidia Docker


distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

#distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
#   && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - \
#   && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
   
sudo apt-get update 
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
sudo systemctl status docker

# Check Docker image
sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi

exit 0

## Running GUI Applications
xhost +local:docker
sudo docker run --gpus all -it \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    nathzi1505:darknet bash
