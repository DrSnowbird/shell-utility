#!/bin/bash -x

set -e

CONT_YES=1
function askToContinue() {
    echo -e "Warning: $1"
    read -p "Are you sure to continue (Yes/No)?" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo ".... do dangerous stuff"
    else
        echo -e ">>> Abort! ..."
        CONT_YES=0
        exit 1
    fi
}
echo $CONT_YES
askToContinue

####################################
#### ---- Graphics Driver: ---- ####
####################################
echo "ref: https://medium.com/analytics-vidhya/install-cuda-11-2-cudnn-8-1-0-and-python-3-9-on-rtx3090-for-deep-learning-fcf96c95f7a1"
function graphics_driver() {
    sudo add-apt-repository ppa:graphics-drivers/ppa -y
    sudo apt-get update
    ubuntu-drivers devices
}
# graphics_driver


##################################
#### ---- NVIDIA Driver: ---- ####
##################################
function nvidia_driver() {
    #### ---- find the latest suitable NVIDIA Driver version package ---- ####
    #RECOMMENDED_DRIVER=`ubuntu-drivers devices 2>&1 |grep -i recommended|awk '{print $3}'|grep "^nvidia"`
    RECOMMENDED_DRIVER=`ubuntu-drivers devices |grep "recommended"|awk '{print $3}' `
    #RECOMMENDED_DRIVER=nvidia-driver-470

    echo -e "RECOMMENDED_DRIVER= ${RECOMMENDED_DRIVER}"

    if [ "${RECOMMENDED_DRIVER}" == "" ]; then
        echo "**** ERROR: Can't find RECOMMENDED Nvidia Driver item to install! Abort!"
        exit 1
    else
        echo ">>>> RECOMMENDED_DRIVER=${RECOMMENDED_DRIVER}"
    fi
    askToContinue
    
    sudo apt install -y ${RECOMMENDED_DRIVER}
    echo "Once the installation is completed, reboot your system:"
    echo "sudo reboot"
    echo "When the system is back, you can view the status of the graphic card using the nvidia-smi monitoring tool:"
    # sudo apt-get install nvidia-driver-${NVIDIA_DRIVER_VERSION}
    #nvidia-smi
}
# nvidia_driver

##################################
#### ---- CUDA TOOLKIT: ----  ####
##################################
#wget https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda_11.2.2_${NVIDIA_DRIVER_VERSION}.32.03_linux.run
function cuda_toolkit() {
    # wget https://developer.download.nvidia.com/compute/cuda/11.6.2/local_installers/cuda_11.6.2_510.47.03_linux.run
    #CUDA_TOOLKIT=cuda_11.5.0_495.29.05_linux.run
    CUDA_TOOLKIT=cuda_11.6.2_510.47.03_linux.run
    wget https://developer.download.nvidia.com/compute/cuda/11.5.0/local_installers/${CUDA_TOOLKIT}
    echo "-------------------------------------------------------------"
    echo "-------------------------------------------------------------"
    echo "Remember: DO NOT check the option of installing the driver!!!"
    echo "-------------------------------------------------------------"
    echo "-------------------------------------------------------------"
    sudo sh ${CUDA_TOOLKIT}
    rm ${CUDA_TOOLKIT}
}
#cuda_toolkit
# Nvidia driver already includes CUDA

##################################
#### ---- cudnn toolkit: ---- ####
##################################
#echo "----- Download CUDA cuDNN v8.1.0 ...."
#wget https://developer.nvidia.com/compute/machine-learning/cudnn/secure/8.1.0.77/11.2_20210127/cudnn-11.2-linux-x64-v8.1.0.77.tgz
#tar -zvxf cudnn-11.2-linux-x64-v8.1.0.77.tgz

#### ---- main ---- ####
graphics_driver
nvidia_driver
cuda_driver


