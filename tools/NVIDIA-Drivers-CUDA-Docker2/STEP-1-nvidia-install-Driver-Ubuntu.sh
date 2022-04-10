#!/bin/bash -x

remove_old=0

DRIVER_RUN_DEFAULT=https://us.download.nvidia.com/XFree86/Linux-x86_64/510.60.02/NVIDIA-Linux-x86_64-510.60.02.run
DRIVER_RUN=${1:-$DRIVER_RUN_DEFAULT}

function remove_old_nvidia_driver() {
    if [ $remove_old -gt 0 ]; then
        old_drivers="nvidia cudnn"
        for drv in $old_drivers; do
            old_pkg=`$(dpkg -l | grep ${drv} | awk '{print $2}')`
            if [ "${old_pkg}" != "" ]; then
                sudo dpkg -P $(dpkg -l | grep ${drv} | awk '{print $2}')
                sudo apt autoremove
            fi
        done

        sudo apt update -y
        sudo apt upgrade -y
    fi
}

function install_nvidia_driver() {
    DRIVER_RUN=https://us.download.nvidia.com/XFree86/Linux-x86_64/510.60.02/NVIDIA-Linux-x86_64-510.60.02.run
    wget ${DRIVER_RUN}
    chmod +x ${DRIVER_RUN}
    sudo sh ./${DRIVER_RUN}
}


#### ---- find the latest suitable NVIDIA Driver version package ---- ####
#RECOMMENDED_DRIVER=`ubuntu-drivers devices 2>&1 |grep -i recommended|awk '{print $3}'|grep "^nvidia"`
RECOMMENDED_DRIVER=`ubuntu-drivers devices |grep "recommended"|awk '{print $3}' `
#RECOMMENDED_DRIVER=nvidia-driver-510

function install_recommended_nvidia_driver() {
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
}


# main
## -- choose one only below: -- ##
install_nvidia_driver
#install_recommended_nvidia_driver

nvidia-smi

