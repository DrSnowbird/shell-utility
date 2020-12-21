#!/bin/bash -x

# Ref: https://github.com/cilynx/rtl88x2bu

echo "... Install Required DKMS modules:"
sudo apt list linux-headers-generic build-essential dkms git
sudo apt -y install linux-headers-generic build-essential dkms git

echo "... List USB Devices:"
sudo lsusb

echo "... List USB Devices:"
git clone https://github.com/cilynx/rtl88x2bu.git
cd rtl88x2bu/
VER=$(sed -n 's/\PACKAGE_VERSION="\(.*\)"/\1/p' dkms.conf)
sudo rsync -rvhP ./ /usr/src/rtl88x2bu-${VER}
sudo dkms add -m rtl88x2bu -v ${VER}
sudo dkms build -m rtl88x2bu -v ${VER}
sudo dkms install -m rtl88x2bu -v ${VER}
sudo modprobe 88x2bu
