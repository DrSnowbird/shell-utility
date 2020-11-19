#!/bin/bash -x

#Step-3.1: Setup Default python version to python3
python --version
python3 --version

sudo yum install -y epel-release

pip3 --version

sudo pip3 install virtualenv
sudo pip3 install virtualenvwrapper


#########################################################################
#### ---- Customization for multiple virtual python environment ---- ####
####      (most recommended approach and simple to switch venv)      ####
#########################################################################
function setup_virtualenvwrapper_in_bashrc() {
cat << EOF >> ~/.bashrc
#########################################################################
#### ---- Customization for multiple virtual python environment ---- ####
#########################################################################

# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_PYTHON=\`which python3\`
#source /usr/local/bin/virtualenvwrapper.sh
source \`which virtualenvwrapper.sh\`
#source /home/\${USER}/.local/bin/virtualenvwrapper.sh
export WORKON_HOME=\${BASE_DISK_MOUNT}/Envs
if [ ! -d \$WORKON_HOME ]; then
    mkdir -p \$WORKON_HOME
fi
EOF
}
if [ "`cat $HOME/.bashrc | grep -i virtual`" = "" ]; then
    #if [ "$WORKON_HOME" != "" ]; then
    setup_virtualenvwrapper_in_bashrc
fi

