#!/bin/bash -x

echo "---------------"
echo "usage:"
echo "---------------"
echo "source $0 <your_venv_name>"
echo "--------------------------"
echo ""

export VENV_HOME=${2:-/mnt/seagate-3tb/Envs}
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


function uninstall_intall_venv() {
    python3  -m pip install -U pip

    pip3 uninstall virtualenv
    #pip install --user virtualenv
    pip3 install virtualenv
}

function create_venv() {
    echo "......................"
    echo ".... my_venv= $my_venv"
    echo "......................"
    if [ "`which python3`" = "" ]; then
        echo "*** ERROR: missing python3 installation... Abort now!"
        exit 1
    fi
    ## -- Install 'virtualenv' if not yet installed --
    if [ "`which virtualenv`" = "" ]; then
        #python3  -m pip install --user -U pip
        python3  -m pip install -U pip
        #pip install --user virtualenv
        pip3 install virtualenv
    fi
    #Working with an environment is always preferred, creating an virtual environment in python can be done as follows
    cd ${VENV_HOME}
    python3 -m virtualenv ${my_env}
    #you can replace the my_env with your environment name.
    #Getting into the virtual environment
    source ${my_env}/bin/activate
}

create_venv $my_env


