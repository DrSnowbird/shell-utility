#!/bin/bash -x

#### ---- Reference ----
# https://docs.docker.com/install/linux/docker-ce/ubuntu/

#### ---- remove old version ----
for old in `dpkg -l | grep -i docker | awk '{print $2}' `; do
    sudo apt-get remove -y $old
done

dpkg -l

sudo apt-get remove -y docker-ce docker-engine docker.io containerd runc
sudo apt-get auto-remove -y

#### ---- Get Debian package ----
UBUNTU_CODE_NAME=`cat /etc/os-release | grep "VERSION_CODENAME=bionic" | cut -d'=' -f2 `
DEBIAN_PACKAGE=docker-ce_19.03.0~3-0~ubuntu-${UBUNTU_CODE_NAME}_amd64.deb
# https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce_19.03.0~3-0~ubuntu-bionic_amd64.deb
wget -c https://download.docker.com/linux/ubuntu/dists/${UBUNTU_CODE_NAME}/pool/stable/amd64/${DEBIAN_PACKAGE}
sudo dpkg -i `pwd`/${DEBIAN_PACKAGE}

#rm -f ${DEBIAN_PACKAGE}

#Add your user to the docker group to setup permissions. Make sure to restart your machine after executing this command.
sudo usermod -a -G docker ${USER}

#### ---- Test your Docker installation ---- ####
# Executing the following command will automatically download the hello-world Docker image if it does not exist and run it.
sudo docker run hello-world

#Remove the hello-world image once you're done.

docker image ls

docker rmi -f hello-world

# Install Docker Compose
#This is the new stuff! Docker Compose helps you to run a network of several containers all at once thanks to configuration files instead of providing all arguments in Docker’s command line interface. It makes it easier to manage your containers as command lines can become very long and unreadable due to the high number of arguments.

# Execute the following command in a terminal window to install it.

DOCKER_COMPOSE_RELEASE=`curl -s https://github.com/docker/compose/releases/latest|cut -d'"' -f2`
DOCKER_COMPOSE_RELEASE=$(basename $DOCKER_COMPOSE_RELEASE)

#### ---- Install Docker-compose ---- ####
sudo apt remove -y docker-compose
sudo curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_RELEASE}/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

