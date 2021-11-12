#!/bin/bash -x

remove_old=1
nvidia_pkg=`$(dpkg -l | grep nvidia-driver | awk '{print $2}')`

if [ $remove_old -gt 0 ]; then
    if [ "${nvidia_pkg}" != "" ]; then
        sudo dpkg -P $(dpkg -l | grep nvidia-driver | awk '{print $2}')
        sudo apt autoremove
    fi

    sudo apt update -y
    sudo apt upgrade -y
fi

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

sudo apt install -y ${RECOMMENDED_DRIVER}
echo "Once the installation is completed, reboot your system:"
echo "sudo reboot"
echo "When the system is back, you can view the status of the graphic card using the nvidia-smi monitoring tool:"

nvidia-smi

