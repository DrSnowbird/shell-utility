#!/bin/bash -x

#sudo apt install -y nvidia-driver-455
#wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/rtl_nic/rtl8125a-3.fw
wget https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/rtl_nic/rtl8168fp-3.fw
sudo cp rtl81* /lib/firmware/rtl_nic/
sudo update-initramfs -u

