#!/bin/bash -x

# --- You need setup password less sudo first before running this ---

sudo yum update -y

## -- Git: --
sudo yum install git -y

## -- Python3: --
sudo yum install python3 -y
jj
mkdir ~/git-public
cd git-public/
git clone git@github.com:DrSnowbird/shell-utility.git

#cd ~/git-public/shell-utility/initial-setup/setup

## -- setup: .bashrc: --
mkdir ~/bin
cp ~/git-public/shell-utility/initial-setup/alias/* ~/bin
~/bin/setup_bash_rc_profile.sh

cd ~/git-public/shell-utility/docker/installation
./setup-docker-and-docker-compose-CnetOS.sh
## -- Docker --
#./docker-ce-install-CentOS.sh
## -- docker-compose: --
#./install-docker-compose-latest-release-tag.sh

function setup_JDK11() {
    sudo yum install -y java-11-openjdk-devel
}
setup_JDK11

function setup_python3() {
    sudo yum install -y python3
}
setup_python3

cd ~
docker -v
docker-compose -v

## Setup utility e.g. ack
sudo yum install -y epel-release
sudo yum install -y ack

## install ack, etc tools
~/bin/run-portainer-local.sh

