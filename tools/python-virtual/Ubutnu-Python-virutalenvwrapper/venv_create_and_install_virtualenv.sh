#!/bin/bash -x

echo "---------------"
echo "usage:"
echo "---------------"
echo "source $0 <your_venv_name>"
echo "--------------------------"
echo ""

BASE_DISK_MOUNT=$HOME
if [ -s /mnt/seagate-3tb/ ]; then
    BASE_DISK_MOUNT=/mnt/seagate-3tb
fi
export VENV_HOME=${2:-${BASE_DISK_MOUNT}/Envs}
if [ ! -d ${VENV_HOME} ]; then
    export VENV_HOME=${2:-$HOME/Envs}
    if [ ! -d ${VENV_HOME} ]; then
        mkdir -p ${VENV_HOME}
    fi
fi
echo "......................"
echo ".... VENV_HOME= ${VENV_HOME}"
echo "......................"

my_env=${1:-${VENV_HOME}/my_env}

if [ `which python3` == "" ]; then 
    echo ">>>> ERROR: Python 3 is not install yet! Abort!"
    exit 1
fi

function uninstall_and_intall_venv() {
    sudo python3 -m pip install -U pip

    sudo pip3 uninstall virtualenv
    sudo pip3 install virtualenv 
    sudo pip install virtualenvwrapper
}
if [ "`which virtualenvwrapper.sh`" == "" ]; then
    uninstall_and_intall_venv
fi

function setup_venv_bashrc() {
    if [ "`which virtualenvwrapper.sh`" == "" ]; then
        echo -e "**** ERROR: virtualenvwrapper.sh : NOT Found!"
    else
        venv_setup_already="`cat ~/.bashrc | grep VIRTUALENVWRAPPER_PYTHON`"
        if [ "$venv_setup_already" != "" ]; then
            cat >> ~/.bashrc << EOF
#####################################################
#### ---- Setup: virtual python environment ---- ####
#####################################################

# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_PYTHON=`which python3`
#source /usr/local/bin/virtualenvwrapper.sh
source `which virtualenvwrapper.sh`
#source /home/${USER}/.local/bin/virtualenvwrapper.sh
export WORKON_HOME=${BASE_DISK_MOUNT}/Envs
if [ ! -d $WORKON_HOME ]; then
    mkdir -p $WORKON_HOME
fi
EOF
        fi
    fi

}
setup_venv_bashrc


function create_venv() {
    echo "......................"
    echo ".... my_venv= $my_venv"
    echo "......................"

    cd ${VENV_HOME}
    python3 -m virtualenv ${my_env}
    #you can replace the my_env with your environment name.
    #Getting into the virtual environment
    source ${my_env}/bin/activate
}

#create_venv $my_env


