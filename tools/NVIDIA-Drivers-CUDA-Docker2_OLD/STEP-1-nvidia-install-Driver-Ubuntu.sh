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
        sudo apt check
    fi
}

#function install_nvidia_driver() {
#    DRIVER_RUN=https://us.download.nvidia.com/XFree86/Linux-x86_64/510.60.02/NVIDIA-Linux-x86_64-510.60.02.run
#    wget ${DRIVER_RUN}
#    chmod +x ${DRIVER_RUN}
#    sudo sh ./${DRIVER_RUN}
#}

function dual_display_setup() {
    echo -e ">>>> ---------- Dual Displays Setup/initialization: -----------"
    dkms status
    uname -r

    sudo update-initramfs -u

    echo ".... You may have to reboot the Ubuntu system to let it take effect!"

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

    echo sudo apt install -y ${RECOMMENDED_DRIVER}
    echo -e ">>>> Once the installation is completed, reboot your system:"
    echo -e "     sudo reboot"
    echo -e ">>>> When the system is back, you can view the status of the graphic card using the nvidia-smi monitoring tool:"
}


# main
## -- choose one only below: -- ##
install_recommended_nvidia_driver

echo -e ">>>> Make sure you 'sudo reboot now' ... to make sure Nvidia Driver is applied! ...."
echo -e "Then, you can test Nvidia setup with the commond:"
echo -e "   nvidia-smi"



