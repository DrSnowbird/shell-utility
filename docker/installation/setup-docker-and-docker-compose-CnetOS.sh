#!/bin/bash -x

cd ~
mkdir git-pub

cd git-pub/

#git clone git@github.com:DrSnowbird/shell-utility.git
git clone https://github.com/DrSnowbird/shell-utility.git


#### ---- setup .bash.rc ---- ####
mkdir ~/bin/
cp ~/git-pub/shell-utility/initial-setup/setup/*.sh ~/bin
~/bin/setup_bash_rc_profile.sh

#### ---- docker setup: ---- ####
cd ~/git-pub/shell-utility/docker/installation
./docker-ce-install-CentOS.sh
docker -v

#### ---- docker-compose setup: ---- ####
install-docker-compose-latest-release-tag.sh
docker-compose -v

#### ---- Portainer setup: ---- ####
cd ~
~/bin/run-portainer-local.sh
