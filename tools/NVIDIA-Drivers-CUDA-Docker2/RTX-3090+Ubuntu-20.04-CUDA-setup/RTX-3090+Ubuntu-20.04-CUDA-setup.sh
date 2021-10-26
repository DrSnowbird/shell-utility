#!/bin/bash -x

set -e


echo "ref: https://medium.com/analytics-vidhya/install-cuda-11-2-cudnn-8-1-0-and-python-3-9-on-rtx3090-for-deep-learning-fcf96c95f7a1"

sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt-get update

ubuntu-drivers devices

NVIDIA_DRIVER_VERSION=470
sudo apt-get install nvidia-driver-${NVIDIA_DRIVER_VERSION}

nvidia-smi

wget https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda_11.2.2_${NVIDIA_DRIVER_VERSION}.32.03_linux.run

echo "-------------------------------------------------------------"
echo "-------------------------------------------------------------"
echo "Remember: DO NOT check the option of installing the driver!!!"
echo "-------------------------------------------------------------"
echo "-------------------------------------------------------------"

CONT_YES=1
function askToContinue() {
    read -p "Are you sure to continue (Yes/No)?" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo ".... do dangerous stuff"
    else
        CONT_YES=0
        exit 0
    fi
}
echo $CONT_YES
askToContinue

sudo sh cuda_11.2.2_${NVIDIA_DRIVER_VERSION}.32.03_linux.run

rm cuda_11.2.2_${NVIDIA_DRIVER_VERSION}.32.03_linux.run

echo "----- Download CUDA cuDNN v8.1.0 ...."

wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/8.1.0.77/11.2_20210127/cudnn-11.2-linux-x64-v8.1.0.77.tgz

tar -zvxf cudnn-11.2-linux-x64-v8.1.0.77.tgz



