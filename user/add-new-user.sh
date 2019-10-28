#!/bin/bash 
# ------------------------------------ 
# maintainer: DrSnowbird@openkbs.org
# license: Apache License Version 2.0
# ------------------------------------ 
if [ $# -lt 2 ]; then
    echo "*** ERROR ***"
    echo "... Need two input arguments at least ..."
    echo "$(basename $0) <User_Name> <Password> <sudo_or_not: 1 (yes), 0 (no)>"
    exit 1
fi
USER_SUDO=0
OS_TYPE=centos
HOST_OS=`cat /etc/*-release|grep "^NAME="|awk -F'=' '{print $2}'|tr -d '"'`
#if [ "$(. /etc/os-release; echo $NAME)" = "Ubuntu" ]; then
if [ "$HOST_OS" = "Ubuntu" ]; then
    OS_TYPE=ubuntu
else
    OS_TYPE=centos
fi
if [ $3 -gt 0 ]; then
   USER_SUDO=1
fi
NO_PASSWORD=0

#### ---- main ----
USER_NAME=${1}
USER_PASSWD=${2}
sudo useradd ${USER_NAME} --create-home -U -s /bin/bash -p $(echo ${USER_PASSWD} | openssl passwd -1 -stdin) 
echo "------------------------------------"
echo "To add user to more group:"
echo "sudo usermod -aG <new-Group> ${USER_NAME}"
echo "    Note: The user will need to log out and log back in to see the new group added."
echo "------------------------------------"
echo "To add user to sudo group:"
echo "sudo usermod -aG sudo ${USER_NAME}"
echo "------------------------------------"
if [ ${USER_SUDO} -gt 0 ]; then
    if [ "${OS_TYPE}" = "ubuntu" ]; then
        ## -- Ubuntu --
        sudo usermod -aG sudo ${USER_NAME}
    fi
    if [ "${OS_TYPE}" = "centos" ]; then
        ## -- Centos --
        sudo usermod -aG wheel ${USER_NAME}
    fi
    if [ ${NO_PASSWORD} -gt 0 ]; then
         echo "%${USER_NAME} ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
    fi
fi
sudo chown ${USER_NAME}:${USER_NAME} -R /home/${USER_NAME}

