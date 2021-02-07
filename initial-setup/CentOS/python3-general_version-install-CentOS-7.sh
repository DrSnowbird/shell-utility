#!/bin/bash -x

sudo yum update -y
sudo yum install -y python3

#sudo alternatives --remove python /usr/bin/python2
#sudo alternatives --set python /usr/bin/python3
python --version
python3 --version

sudo pip3 install --upgrade pip

pip3 -V
