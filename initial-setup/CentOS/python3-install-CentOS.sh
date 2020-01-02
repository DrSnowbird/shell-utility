#!/bin/bash -x

sudo yum install -y python36

sudo ln -s /usr/bin/python3.6 /usr/bin/python3

# Setup Default python version to python3
python --version
python3 --version

sudo alternatives --remove python /usr/bin/python2
sudo alternatives --set python /usr/bin/python3
python --version
python3 --version

sudo yum install -y python36-devel

sudo yum install -y python36-setuptools

sudo easy_install-3.6 pip

sudo pip3 install --upgrade pip

pip3 -V
