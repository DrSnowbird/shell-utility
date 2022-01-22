#!/bin/bash -x

set -e

# ref: Nvidia CUDA toolkit installation
# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=20.04&target_type=runfile_local
# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=2004&target_type=deblocal

# ref: nvidia persistence
# https://forums.developer.nvidia.com/t/setting-up-nvidia-persistenced/47986/10

function install_CUDA_toolkit() {
    if [ ! -d /usr/local/cuda ]; then
        mkdir -p cd ~/tmp
        cd ~/tmp

        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
        sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda-repo-ubuntu2004-11-6-local_11.6.0-510.39.01-1_amd64.deb
        sudo dpkg -i cuda-repo-ubuntu2004-11-6-local_11.6.0-510.39.01-1_amd64.deb
        sudo apt-key add /var/cuda-repo-ubuntu2004-11-6-local/7fa2af80.pub
        sudo apt-get update
        sudo apt-get -y install cuda
        rm -f cuda-repo-ubuntu2004-11-6-local_11.6.0-510.39.01-1_amd64.deb
        
        sudo chmod a+r /usr/local/cuda/include/cudnn.h
    fi
}
# -- use this as simpler steps: --
function install_CUDA_toolkit_using_Shell() {
    wget https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run
    sudo sh cuda_11.6.0_510.39.01_linux.run

    ## -- create soft-link
    _CUDA_LIB64=`ls -d /usr/local/cuda-* |head -1`
    if [ -d ${_CUDA_LIB64} ] && [ ! -z "$(ls -A ${_CUDA_LIB64})" ]; then
        sudo rm -rf /usr/local/cuda
        sudo ln -s sudo ln -s /usr/local/cuda-11.6 /usr/local/cuda
    fi
}
install_CUDA_toolkit_using_Shell


function setup_CUDA_LIB_PATH() {
    setup_before=`cat ~/.bashrc|grep '/usr/local/cuda'`
    echo "................ You need to setup your PATH and LIB"
    echo "export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}"
    echo "export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}"
    echo
    if [ "$setup_before" != "" ]; then
#### ---- .bashrc setup ---- ####
cat >> ~/.bashrc << EOF
#### ---- NVIDIA CUDA lib: setup ---- ####
# export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=/usr/local/cuda/bin:${PATH}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:${LD_LIBRARY_PATH}
export CUDA_HOME=/usr/local/cuda
export LD_LIBRARY_PATH=/mnt/data/cuda/lib64:$LD_LIBRARY_PATH
EOF
    else
        echo "---- INFO: Already setup before: setup_CUDA_LIB_PATH"
    fi
}
setup_CUDA_LIB_PATH

source ~/.bashrc

echo
echo ".... Verify driver version:"
cat /proc/driver/nvidia/version
echo ".... Verify the CUDA Toolkit version: "
nvcc -V

#nvcc: NVIDIA (R) Cuda compiler driver"
#Copyright (c) 2005-2021 NVIDIA Corporation
#Built on Sun_Aug_15_21:14:11_PDT_2021
#Cuda compilation tools, release 11.4, V11.4.120
#Build cuda_11.4.r11.4/compiler.30300941_0

echo ".... Persistence mode setup: "
echo "Persistence mode is already Enabled for GPU 00000000:01:00.0.
All done."
sudo -i nvidia-smi -pm 1



function verify_CUDA_job_RHEL() {
    echo "[RHEL]:"
    cd ~/tmp
    cuda-install-samples-7.5.sh .
    cd NVIDIA_CUDA-7.5_Samples
    make
}
function verify_CUDA_job_Ubuntu() {
    echo "[Ubuntu]:"
    cd ~/tmp
    apt-get install cuda-samples-7-0 -y
    cd /usr/local/cuda-7.0/samples
    make
}
verify_CUDA_job_Ubuntu
