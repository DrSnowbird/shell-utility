#!/bin/bash -x

set -e

# ref: Nvidia CUDA toolkit installation
# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=20.04&target_type=runfile_local
# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=2004&target_type=deblocal
# (2023-04-08) https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local

# ref: nvidia persistence
# https://forums.developer.nvidia.com/t/setting-up-nvidia-persistenced/47986/10

function install_CUDA_toolkit() {
    if [ ! -d /usr/local/cuda ]; then
        mkdir -p cd ~/tmp
        cd ~/tmp

        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
        sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/12.1.0/local_installers/cuda-repo-ubuntu2204-12-1-local_12.1.0-530.30.02-1_amd64.deb
        sudo dpkg -i cuda-repo-ubuntu2204-12-1-local_12.1.0-530.30.02-1_amd64.deb
        sudo cp /var/cuda-repo-ubuntu2204-12-1-local/cuda-*-keyring.gpg /usr/share/keyrings/
        sudo apt-get update
        sudo apt-get -y install cuda
        rm -f cuda-repo-ubuntu2004-11-6-local_11.6.0-510.39.01-1_amd64.deb
        
        sudo chmod a+r /usr/local/cuda/include/cudnn.h
    fi
}
install_CUDA_toolkit

# -- use this as simpler steps: --
#function install_CUDA_toolkit_using_Shell() {
#    wget https://developer.download.nvidia.com/compute/cuda/11.6.0/local_installers/cuda_11.6.0_510.39.01_linux.run
#    sudo sh cuda_11.6.0_510.39.01_linux.run

    ## -- create soft-link#
    _CUDA_LIB64=`ls -d /usr/local/cuda-* |head -1`
#    if [ -d ${_CUDA_LIB64} ] && [ ! -z "$(ls -A ${_CUDA_LIB64})" ]; then
#        sudo rm -rf /usr/local/cuda
#        sudo ln -s sudo ln -s /usr/local/cuda-12.1 /usr/local/cuda
#    fi
#}
# (out-of-date) install_CUDA_toolkit_using_Shell


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
# export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
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



function verify_CUDA_job_Ubuntu() {
    echo "[Ubuntu]:"
    cd ~/tmp
    apt-get install cuda-samples-12.1 -y
    cd /usr/local/cuda-12.1/samples
    make
}
verify_CUDA_job_Ubuntu
