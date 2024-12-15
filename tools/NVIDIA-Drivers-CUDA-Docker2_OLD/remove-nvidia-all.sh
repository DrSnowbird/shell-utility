#!/bin/bash -x

sudo apt-get --purge -y remove 'cuda*'
sudo apt-get --purge -y remove 'nvidia*'
sudo /usr/bin/nvidia-uninstall
echo "****** You need to reboot to take effect: sudo reboot now" 

