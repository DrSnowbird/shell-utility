#!/bin/bash -x 

# ref: https://github.com/NVIDIA/nvidia-docker/tree/master#upgrading-with-nvidia-docker2-deprecated

# Ubuntu 16.04/18.04, Debian Jessie/Stretch
# Add the package repositories
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-container-toolkit
sudo systemctl restart docker

sleep 15

#### ---- Test nvidia-docker ----
docker run --gpus all nvidia/cuda:9.0-base nvidia-smi
