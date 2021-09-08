#!/bin/bash -x

sudo apt -y clean # clean list of cached packages so Ubuntu Software can read them
sudo apt -y update # && sudo apt upgrade

sudo apt-get --purge --reinstall install -y gnome-software

#sudo apt autoremove -y gnome-software && sudo apt install -y gnome-software
