#!/bin/bash -x

# Nvidia Container toolkit
# ref: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker
# ref: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#installing-with-apt

docker --version

# Add the nvidia-docker package repositories

distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
echo -e ">>> OS distribution: ${distribution}"

# 1. -- Configure the production repository:
curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
  && curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 1.a. -- Optionally, configure the repository to use experimental packages:
# sed -i -e '/experimental/ s/^#//g' /etc/apt/sources.list.d/nvidia-container-toolkit.list

# 2. -- Update the packages list from the repository:
sudo apt-get update

# 3. -- Install the NVIDIA Container Toolkit packages:
sudo apt-get install -y nvidia-container-toolkit
sudo apt-get autoremove -y
sudo service docker restart
sudo service docker status

# Check Docker image
#CUDA_IMAGE=nvidia/cuda:12.6.3-devel-ubuntu24.04
CUDA_IMAGE=nvidia/cuda:12.6.3-devel-ubuntu22.04
sudo docker pull ${CUDA_IMAGE}
sudo docker run --rm --gpus all ${CUDA_IMAGE} nvidia-smi

exit 0

## Running GUI Applications
xhost +local:docker
sudo docker run --gpus all -it \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    ${CUDA_IMAGE} bash

