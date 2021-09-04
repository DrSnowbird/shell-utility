#!/bin/bash -x

RECOMMENDED_DRIVER=`ubuntu-drivers devices 2>&1 |grep -i recommended|awk '{print $3}'|grep "^nvidia"`

echo ">>>> RECOMMENDED_DRIVER=${RECOMMENDED_DRIVER}"

sudo apt install -y ${RECOMMENDED_DRIVER}

echo "Once the installation is completed, reboot your system:"

echo "sudo reboot"

echo "When the system is back, you can view the status of the graphic card using the nvidia-smi monitoring tool:"

echo "nvidia-smi"
