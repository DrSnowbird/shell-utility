#!/bin/bash -x

#Step-3.1: Setup Default python version to python3
python --version
python3 --version

sudo yum install -y epel-release

pip3 --version

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
setup_virtualenvwrapper_in_bashrc:wq
