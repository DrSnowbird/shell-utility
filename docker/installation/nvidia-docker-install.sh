#!/bin/bash -x 

# ref: https://github.com/NVIDIA/nvidia-docker/tree/master#upgrading-with-nvidia-docker2-deprecated

# https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker

function install_NVIDIA_driver_lates() {
	nvidia_pkg=`$(dpkg -l | grep nvidia-driver | awk '{print $2}')`
	if [ "${nvidia_pkg}" != "" ]; then
	    sudo dpkg -P $(dpkg -l | grep nvidia-driver | awk '{print $2}')
	    sudo apt autoremove
	fi

	sudo apt update -y
	sudo apt upgrade -y
    RECOMMENDED_DRIVER=`ubuntu-drivers devices 2>&1 |grep -i recommended|awk '{print $3}'|grep "^nvidia"`

    echo ">>>> RECOMMENDED_DRIVER=${RECOMMENDED_DRIVER}"
    sudo apt install -y ${RECOMMENDED_DRIVER}
    echo "Once the installation is completed, reboot your system:"
    echo "sudo reboot"
    echo "When the system is back, you can view the status of the graphic card using the nvidia-smi monitoring tool:"
    echo "nvidia-smi"
}
install_NVIDIA_driver_lates

function install_NVIDIA_docker_v2() {
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)    && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -    && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    curl -s -L https://nvidia.github.io/nvidia-container-runtime/experimental/$distribution/nvidia-container-runtime.list | sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
    sudo apt-get update
    sudo apt-get install -y nvidia-docker2
    sudo systemctl restart docker
    sleep 15
    sudo docker run --rm --gpus all nvidia/cuda:11.0-base nvidia-smi
}
install_NVIDIA_docker_v2
