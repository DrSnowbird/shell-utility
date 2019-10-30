#!/bin/bash -x

mkdir git-public

cd git-public/
git clone git@github.com:DrSnowbird/shell-utility.git

cd shell-utility
cd ~/git-pub/shell-utility/initial-setup/setup

mkdir ~/bin/
cp *.sh ~/bin

~/bin/setup_bash_rc_profile.sh

cd ~/git-pub/shell-utility/docker/installation

./docker-ce-install-CentOS.sh

install-docker-compose-latest-release-tag.sh

docker -v

docker-compose -v


## install ack, etc tools
~/bin/run-portainer-local.sh

## Setup utility e.g. ack
sudo yum install -y epel-release
Sudo yum install -y ack


