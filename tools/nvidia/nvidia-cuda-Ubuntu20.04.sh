#!/bin/bash -x

# ref: Nvidia CUDA toolkit installation
# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&target_distro=Ubuntu&target_version=2004&target_type=deblocal

# ref: nvidia persistence
# https://forums.developer.nvidia.com/t/setting-up-nvidia-persistenced/47986/10

function install_CUDA_toolkit() {
    if [ ! -d /usr/local/cuda ]; then
        cd ~/tmp

        wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-ubuntu2004.pin
        sudo mv cuda-ubuntu2004.pin /etc/apt/preferences.d/cuda-repository-pin-600
        wget https://developer.download.nvidia.com/compute/cuda/11.2.2/local_installers/cuda-repo-ubuntu2004-11-2-local_11.2.2-460.32.03-1_amd64.deb
        sudo dpkg -i cuda-repo-ubuntu2004-11-2-local_11.2.2-460.32.03-1_amd64.deb
        sudo apt-key add /var/cuda-repo-ubuntu2004-11-2-local/7fa2af80.pub
        sudo apt-get update
        sudo apt-get -y install cuda

        rm -f cuda-repo-ubuntu2004-11-2-local_11.2.2-460.32.03-1_amd64.deb
    fi
}
install_CUDA_toolkit

echo "................ You need to setup your PATH and LIB"
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

echo
echo ".... Verify driver version:"
cat /proc/driver/nvidia/version
echo ".... Verify the CUDA Toolkit version: "
nvcc -V

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
