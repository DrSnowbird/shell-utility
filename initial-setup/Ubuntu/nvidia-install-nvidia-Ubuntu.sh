#!/bin/bash -x

sudo dpkg -P $(dpkg -l | grep nvidia-driver | awk '{print $2}')
sudo apt autoremove

sudo apt update -y
sudo apt upgrade -y
