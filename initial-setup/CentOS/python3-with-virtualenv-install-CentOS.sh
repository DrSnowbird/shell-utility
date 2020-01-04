#!/bin/bash -x

#Step-1: Open a Terminal and add the repository to your Yum install.
sudo yum install -y https://centos7.iuscommunity.org/ius-release.rpm

#Step-2: Update Yum to finish adding the repository.
sudo yum -y update

#Step-3: Download and install Python.
#This will not only install Python – but it will also install pip to help you with installing add-ons.
sudo yum install -y python36u python36u-libs python36u-devel python36u-pip

#Once these commands are executed, simply check if the correct version of Python has been installed by executing the following command:
python3.6 -V

#Step-3.1: Setup Default python version to python3
python --version
python3 --version

sudo alternatives --remove python /usr/bin/python2
sudo alternatives --set python /usr/bin/python3
python --version
python3 --version

sudo yum install -y epel-release

pip3 --version
pip3 install --user virtualenvwrapper
pip install --upgrade pip
pip3 install --user --upgrade pip
sudo pip3 install virtualenv
sudo pip3 install virtualenvwrapper

function setup_virtualenvwrapper_in_bashrc() {
cat << EOF >> ~/.bashrc
    #########################################################################
    #### ---- Customization for multiple virtual python environment ---- ####
    #########################################################################

    export WORKON_HOME=~/Envs
    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    if [ -s /usr/local/bin/virtualenvwrapper.sh ]; then
        source /usr/local/bin/virtualenvwrapper.sh
    elif [ -s ~/.local/bin/virtualenvwrapper.sh ]; then
        source ~/.local/bin/virtualenvwrapper.sh
    fi
    if [ ! -d $WORKON_HOME ]; then
        mkdir -p $WORKON_HOME
    fi
EOF
}
cp .bashrc .bashrc.SAVE.`date +%F`
setup_virtualenvwrapper_in_bashrc
