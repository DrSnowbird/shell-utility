#!/bin/bash -x

set -e

remove_old=1

CONT_YES=1
function askToContinue() {
    echo -e "Warning: $1"
    read -p "Are you sure to continue (Y or N)?" -n 1 -r
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

echo -e " ... continue ..."

function remove_old_nvidia_driver() {
    if [ $remove_old -gt 0 ]; then
        #old_drivers="^nvidia- ^cuda- ^cuda- ^libnvidia cudnn"
        #for drv in $old_drivers; do
        #    old_pkg=`$(dpkg -l | grep ${drv} | awk '{print $2}')`
        #    if [ "${old_pkg}" != "" ]; then
        #        sudo dpkg -P $(dpkg -l | grep ${drv} | awk '{print $2}')
        #        sudo apt autoremove
        #    fi
        done
        sudo apt-get remove --purge '^nvidia-.*' -y
        sudo apt-get remove --purge '^libnvidia-.*' -y
        sudo apt-get remove --purge '^cuda-.*' -y
        sudo apt autoremove -y
        sudo apt update -y
        sudo apt upgrade -y
    fi
}
remove_old_nvidia_driver


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

    echo -e ".... To Install Nvidia driver: ${RECOMMENDED_DRIVER}"
    sudo apt install -y ${RECOMMENDED_DRIVER}
}

# main
## -- choose one only below: -- ##
install_recommended_nvidia_driver
dual_display_setup

echo -e ">>>> Once the installation is completed, make sure you reboot the system:\n"
echo -e "     sudo reboot now "
echo -e " "
echo -e ">>>> Once the system is back, you can test Nvidia setup with the commond:\n"
echo -e "     nvidia-smi"

