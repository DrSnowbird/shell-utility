#!/bin/bash -x

# maintainer DrSnowbird@gmail.com

# Uninstall old versions
sudo systemctl stop docker
sudo rm /etc/systemd/system/docker.service.d/override.conf
sudo rm /etc/modules-load.d/overlay.conf
sudo rm /etc/docker/daemon.json
sudo rm -rf /var/lib/docker

sudo yum remove -y docker docker-ce \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-selinux \
                  docker-engine-selinux \
                  docker-engine

## Ref: https://docs.docker.com/install/linux/docker-ce/centos/#set-up-the-repository

# 1.) Install required packages. yum-utils provides the yum-config-manager utility, and device-mapper-persistent-data and lvm2 are required by the devicemapper storage driver.

sudo yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# 2.) Install Docker-CE
sudo yum install docker-ce

# 3.) Enable, Start, and check status of Docker-CE:
sudo systemctl start docker
sudo systemctl status docker
sudo systemctl enable docker
sudo docker ps -a
sudo docker --version

####### dockder-compose ########
# Install Extra Packages for Enterprise Linux

sudo curl -L "https://github.com/docker/compose/releases/download/1.23.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose version

