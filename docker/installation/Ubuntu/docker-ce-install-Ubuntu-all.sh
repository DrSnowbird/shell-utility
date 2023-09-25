#!/bin/bash -x

#### ---- Reference ---- ####
#### ---- Please use official Docker website for the latest installation: ---- ####
# https://docs.docker.com/engine/install/ubuntu/

REMOVE_OLD=${1:-false}

function yesNoContinue() {
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
}
    
function remove_old_docker() {
    #### ---- remove old version ----
    for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do 
        sudo apt-get remove -y $pkg; 
    done


    #dpkg -l
    sudo apt-get remove -y docker docker-ce docker-engine docker.io containerd runc
}
if [ "${REMOVE_OLD}" = "true" ]; then
    remove_old_docker
else
    echo ">>> Old Docker not existing!"
    docker -v
fi

function install_new_docker() {
    #### ---- install new version ----
    sudo apt-get update -y
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

    #### ---- Add Docker’s official GPG key ----
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources:
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update


    #### ---- Install Docker Community Edition ---- ####
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl --now enable docker
    sudo systemctl status docker

    #Add your user to the docker group to setup permissions. Make sure to restart your machine after executing this command.
    sudo usermod -a -G docker ${USER}

    #### ---- Test your Docker installation ---- ####
    # Executing the following command will automatically download the hello-world Docker image if it does not exist and run it.
    sudo docker run hello-world

    docker -v
    docker image ls
    docker rmi -f hello-world
}
if [ "`which docker`" = "" ]; then
    install_new_docker
else
    echo ">>> Docker already installed!"
    docker -v
fi

function install_docker_compose() {
    # Install Docker Compose
    #This is the new stuff! Docker Compose helps you to run a network of several containers all at once thanks to configuration files instead of providing all arguments in Docker’s command line interface. It makes it easier to manage your containers as command lines can become very long and unreadable due to the high number of arguments.

    # Execute the following command in a terminal window to install it.

    #DOCKER_COMPOSE_RELEASE=`curl -s https://github.com/docker/compose/releases/latest | cut -d'"' -f2 | cut -d'/' -f8-`
    sudo apt-get install -y jq
    DOCKER_COMPOSE_RELEASE=`curl -s https://api.github.com/repos/docker/compose/releases/latest | jq .name -r`

    echo
    echo "...>> Latest: docker/compose: release=${release}"
    echo

    #### ---- Install Docker-compose ---- ####
    #sudo apt remove -y docker-compose
    sudo curl -kL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_RELEASE}/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
    sudo chmod +x /usr/bin/docker-compose
    docker-compose -v
}

if [ "`which docker-compose`" = "" ]; then
    install_docker_compose
else
    echo ">>> docker-compose already installed!"
    docker-compose -v
fi
