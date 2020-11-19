#!/bin/bash -x

BASE_DIR=~/git-public/shell-utility

function setup_git_shell_utility() {
    cd ~
    mkdir git-public
    cd git-public/
    
    #git clone git@github.com:DrSnowbird/shell-utility.git
    git clone https://github.com/DrSnowbird/shell-utility.git
}
setup_git_shell_utility

function setup_docker_and_compose() {
    #### ---- setup .bash.rc ---- ####
    mkdir ~/bin/
    cp ${BASE_DIR}/initial-setup/alias/*.sh ~/bin
    ~/bin/setup_bash_rc_profile.sh
    
    #### ---- docker setup: ---- ####
    cd ${BASE_DIR}/docker/installation
    ./docker-ce-install-CentOS.sh
    docker -v
    
    #### ---- docker-compose setup: ---- ####
    cd ${BASE_DIR}/docker/installation
    ./install-docker-compose-latest-release-tag.sh
    docker-compose -v
}
setup_docker_and_compose

function no_sudo_docker() {
    # To create the docker group and add your user:
    # Create the docker group.
    # Add your user to the docker group.
    # After done, Log out and log back in so that your group membership is re-evaluated.
    sudo groupadd docker
    sudo usermod -aG docker $USER
    
    # On Linux, you can also run the following command to activate the changes to groups:
    newgrp docker 
    #Verify that you can run docker commands without sudo.
    docker run hello-world
}
no_sudo_docker

function run_portainer() {
    #### ---- Portainer setup: ---- ####
    portainer_script="run-portainer-local.sh"
    portainer_script_path=`find ${BASE_DIR} -name ${portainer_script} | head -n 1`
    #cd ${BASE_DIR}
    #./docker/portainer/run-portainer-local.sh
    #cp ./docker/portainer/run-portainer-local.sh ~/bin/run-portainer-local.sh
    cp ${portainer_script_path} ~/bin/
    ~/bin/${portainer_script}
}
run_portainer
