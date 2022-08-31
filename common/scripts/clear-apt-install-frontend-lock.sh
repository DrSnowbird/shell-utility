#!/bin/bash -x

# ref: https://askubuntu.com/questions/1109982/e-could-not-get-lock-var-lib-dpkg-lock-frontend-open-11-resource-temporari

function usage() {
	echo -e "$0 [1: more clearing, 0: none]"
	echo
}
usage

sudo killall apt apt-get

function more_clearing() {
    sudo rm /var/lib/apt/lists/lock
    sudo rm /var/cache/apt/archives/lock
    sudo rm /var/lib/dpkg/lock*

    # then reconfigure the packages. Run in terminal:

    sudo dpkg --configure -a
    sudo apt update
}

if [ $1 -gt 0 ]; then
    more_clearing
fi
