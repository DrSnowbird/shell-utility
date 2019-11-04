#!/bin/bash -x

sudo yum install -y python36

sudo yum install -y python36-devel

sudo yum install -y python36-setuptools

sudo easy_install-3.6 pip

sudo pip3 install --upgrade pip

pip3 -V
