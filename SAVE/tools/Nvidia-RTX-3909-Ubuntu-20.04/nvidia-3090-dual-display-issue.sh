#!/bin/bash -x

dkms status
uname -r

sudo update-initramfs -u

echo ".... You may have to reboot the Ubuntu system to let it take effect!"

