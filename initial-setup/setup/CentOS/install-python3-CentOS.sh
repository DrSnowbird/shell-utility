#!/bin/bash -x

#Step 1: Open a Terminal and add the repository to your Yum install.
sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm

#Step 2: Update Yum to finish adding the repository.
sudo yum -y update

#Step 3: Download and install Python.
#This will not only install Python – but it will also install pip to help you with installing add-ons.
sudo yum install -y python36u python36u-libs python36u-devel python36u-pip

#Once these commands are executed, simply check if the correct version of Python has been installed by executing the following command:
python3.6 -V

sudo pip3 install virtualenv
sudo pip3 install virutalenvwrapper
