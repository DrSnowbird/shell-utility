#!/bin/bash -x 

# ref: https://github.com/NVIDIA/nvidia-docker/tree/master#upgrading-with-nvidia-docker2-deprecated

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker

function install_NVIDIA_driver_latest() {
    nvidia_pkg=`$(dpkg -l | grep nvidia-driver | awk '{print $2}')`
    remove_old=0
    if [ $remove_old -gt 0 ]; then
        if [ "${nvidia_pkg}" != "" ]; then
            sudo dpkg -P $(dpkg -l | grep nvidia-driver | awk '{print $2}')
            sudo apt autoremove
        fi

        sudo apt update -y
        sudo apt upgrade -y
    fi
	
    RECOMMENDED_DRIVER=`ubuntu-drivers devices |grep "recommended"|awk '{print $3}' `
    #nvidia-driver-470

    #RECOMMENDED_DRIVER=`ubuntu-drivers devices 2>&1 |grep -i recommended|awk '{print $3}'|grep "^nvidia"`

    if [ "${RECOMMENDED_DRIVER}" == "" ]; then
        echo "**** ERROR: Can't find RECOMMENDED Nvidia Driver item to install! Abort!"
        exit 1
    else
        echo ">>>> RECOMMENDED_DRIVER=${RECOMMENDED_DRIVER}"
    fi

    sudo apt install -y ${RECOMMENDED_DRIVER}
    echo "Once the installation is completed, reboot your system:"
    echo "sudo reboot"
    echo "When the system is back, you can view the status of the graphic card using the nvidia-smi monitoring tool:"

    echo "nvidia-smi"

}
install_NVIDIA_driver_latest

#### ---- Setup: NVIDIA lib path in .bashrc: ---- ####
function setup_bashrc_Nvidia_lib() {
    if [ "`cat $HOME/.bashrc | grep -i 'cuda/lib64'`" != "" ]; then
        ">>>> INFO: setup_bashrc_Nvidia_lib(): setup Nvidia lib path was done before! Ignore!"
    else
        cat >> ~/.bashrc << EOF
export PATH=/usr/local/cuda/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
EOF
    fi
    source ~/.bashrc
}
setup_bashrc_Nvidia_lib

#### ---- Install: Docker if not found: ---- ####
function install_Docker_CE_if_needed() {
    if [ "`which docker`" == "" ]; then
         ./nvidia-docker-install.sh
    fi
}
install_Docker_CE_if_needed

#### ---- Install: NVIDIA Docker2: ---- ####
function install_NVIDIA_docker_v2() {
    # ref: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)    && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -    && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    curl -s -L https://nvidia.github.io/nvidia-container-runtime/experimental/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
    sudo apt-get update
    sudo apt-get install -y nvidia-docker2
    sudo systemctl restart docker
    sleep 5
    sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
}
install_NVIDIA_docker_v2


