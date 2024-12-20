#!/bin/bash -x

#### ---- Reference ---- ####
#### ---- Please use official Docker website for the latest installation: ---- ####
# https://docs.docker.com/engine/install/ubuntu/
# updated: 2024-12-14

REMOVE_OLD=${1:-false}

function yesNoContinue() {
    read -p "Are you sure? " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        exit 1
    fi
}
echo -e ">>> This installation is for Ubuntu 24.04 ..."
echo -e ">>> WARNING: this installation will automatically remove all OLD Docker and docker-compose"
yesNoContinue

exit 0

 
function remove_old_docker() {
    #### ---- remove old version ----
    for pkg in docker.io docker-doc docker-compose docker-ce docker-compose-v2 podman-docker containerd runc; do 
    	sudo apt-get remove -y $pkg; 
    done
    sudo apt-get remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
}

if [ "${REMOVE_OLD}" = "true" ]; then
    remove_old_docker
else
    echo ">>> NOT to remove old docker!"
    docker -v
    exit 0
fi

function install_new_docker() {
    # 1. Add Docker's official GPG key:
    sudo apt-get update
    # sudo apt-get install -y ca-certificates curl
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc
    
    # 2. Add the repository to Apt sources:
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # 3. Install Docker Community Edition ---- ####
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo service docker enable --now
    sudo service docker status

    # 4. Add your user to the docker group to setup permissions. 
    #    Make sure to restart your machine after executing this command.
    sudo usermod -a -G docker ${USER}

    #### ---- Test your Docker installation ---- ####
    # 5. Executing the following command will automatically download the hello-world Docker image 
    #    if it does not exist and run it.
    sudo docker run hello-world

    docker -v
    docker ps
    docker image ls
    docker rmi -f hello-world
    
    echo 
    echo -e ">>> SUCCESS: Install docker-ce and docker-compose ... (if nothing go wrong)"
    echo
}


function install_docker_compose_plugin() {
    # ref: https://docs.docker.com/compose/install/linux/#install-using-the-repository
    sudo apt-get update
    sudo apt-get install docker-compose-plugin
}

function install_docker_compose() {
    # (This is obsolete now as 2024-12-14)
    # Execute the following command in a terminal window to install it.

    #DOCKER_COMPOSE_RELEASE=`curl -s https://github.com/docker/compose/releases/latest | cut -d'"' -f2 | cut -d'/' -f8-`
    sudo apt-get install -y jq
    DOCKER_COMPOSE_RELEASE=`curl -s https://api.github.com/repos/docker/compose/releases/latest | jq .name -r`
    DOCKER_COMPOSE_RELEASE=${DOCKER_COMPOSE_RELEASE:-latest}
    echo
    echo "...>> Latest: docker/compose: release=${release}"
    echo

    #### ---- Install Docker-compose ---- ####
    #sudo apt remove -y docker-compose
    sudo curl -kL https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_RELEASE}/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
    sudo chmod +x /usr/bin/docker-compose
    docker-compose -v
}


if [ "`which docker`" = "" ]; then
    install_new_docker
else
    echo ">>> Docker already installed!"
    docker -v
fi

if [ "`which docker-compose`" = "" ]; then
    # install_docker_compose
    echo -e ">>> docker-compose not found though installed!"
    echo -e ">>> Do you want to install 'docker-compose plugin again' ?"
    install_docker_compose_plugin
    if [ "`which docker-compose`" = "" ]; then
        echo ">>> Something went wrong! Can't install 'docker-compose plugin! Abort now! ..."
        exit 1
    else:
        echo ">>> docker-compose already installed!"
        docker-compose -v
    fi
else:
    echo ">>> docker-compose already installed!"
    docker-compose -v
fi
