#!/bin/bash -x

my_venv=${1:-jupyter_venv}
echo "......................"
echo ".... my_venv= $my_venv"
echo "......................"
    
export WORKON_HOME=${2:-/mnt/seagate-3tb/Envs}
if [ ! -d ${WORKON_HOME} ]; then
    export WORKON_HOME=${2:-$HOME/Envs}
    if [ ! -d ${WORKON_HOME} ]; then
        mkdir -p ${WORKON_HOME}
    fi
fi
echo "......................"
echo ".... WORKON_HOME= ${WORKON_HOME}"
echo "......................"


function uninstall_intall_venv() {
    python3  -m pip install -U pip

    sudo pip3 uninstall virtualenv
    #pip install --user virtualenv
    sudo pip3 install virtualenv
    
    sudo pip install virtualenvwrapper
}

if [ "`which virtualenvwrapper.sh`" ]; then
    uninstall_intall_venv
fi

#########################################################################
#### ---- Customization for multiple virtual python environment ---- ####
#########################################################################

# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
#source /usr/local/bin/virtualenvwrapper.sh
source `which virtualenvwrapper.sh`
#source /home/user1/.local/bin/virtualenvwrapper.sh


source `which virtualenvwrapper.sh`

mkvirtualenv ${my_venv}

