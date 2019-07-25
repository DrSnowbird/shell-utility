#!/bin/bash -x

#### ---- Reference ----
# https://docs.docker.com/install/linux/docker-ce/ubuntu/

#### ---- remove old version ----
for old in `dpkg -l | grep -i docker | awk '{print $2}' `; do
    sudo apt-get remove -y $old
done

dpkg -l
sudo apt-get remove -y docker docker-ce docker-engine docker.io containerd runc

#### ---- install new version ----
sudo apt-get update -y

sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-commo

#### ---- Add Docker’s official GPG key ----
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

#### ---- Install Docker Community Edition ---- ####
sudo apt-get update -y
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

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

