#!/bin/bash
  
if [ $# -lt 1 ]; then
    echo "Need project directory name for creating venv... Abort now!"
    echo "---- Usage-1: "
    echo "    source $(basename $0) <PROJECT_HOME_name> "
    echo "---- Usage-2: (assuming you install virtualenvwrapper and virutalenv)"
    echo "    mkvirtualenv ${PROJECT_HOME}"
    echo "    workon ${PROJECT_HOME}"
    exit 1
fi

PROJECT_HOME=${1:-my_venv}

PYTHON_VERSION=3

function uninstall_intall_venv() {
    # sudo apt-get install python3 python3-dev python3-setuptools python3-pip
    python3  -m pip install -U pip

    sudo pip3 uninstall virtualenv
    #pip install --user virtualenv
    sudo pip3 install virtualenv
    
    sudo pip install virtualenvwrapper
}

###########################################################################
#### ---------------------- DON'T CHANGE BELOW ----------------------- ####
###########################################################################

#### ---- Detect [python3] is installed ---- ####
#### common location: /usr/bin/python3
VENV_SETUP=`cat ~/.bashrc | grep -i VIRTUALENVWRAPPER_PYTHON`
if [ ! "${VENV_SETUP}" = "" ]; then
    echo ".. virtualenvwrapper alreay has been setup!"
    exit 0
fi

#### ---- Detect [python3] is installed ---- ####
#### common location: /usr/bin/python3
PYTHON_EXE=`which python${PYTHON_VERSION}`
if [ "${PYTHON_EXE}" = "" ]; then
    echo "**** ERROR: Can't find ${PYTHON_EXE} ! .. Abort setup!"
    exit 1
fi

#### ---- Detect [virtualenv] is installed ---- ####
#### common location: /usr/local/bin/vi:rtualenv
VIRTUALENV_EXE=`which virtualenv`
if [ "${VIRTUALENV_EXE}" = "" ]; then
    echo "**** ERROR: Can't find virtualenv execut:able ! .. Abort setup!"
    exit 1
fi

#### ---- Detect [virtualenvwrapper] is installed ---- ####
#### common location: /usr/local/bin/virtualenvwrapper.sh

if [ "`which virtualenvwrapper.sh`" = "" ]; then
    echo "To unisntll: call uninstall_intall_venv"
fi
VIRTUALENVWRAPPER_SHELL=`which virtualenvwrapper.sh`
if [ "${VIRTUALENVWRAPPER_SHELL}" = "" ]; then
    echo "**** ERROR: Can't find virtualenvwrapper.sh script! .. Abort setup!"
    exit 1
fi

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
export VIRTUALENVWRAPPER_PYTHON=`which python3`
#source /usr/local/bin/virtualenvwrapper.sh
source `which virtualenvwrapper.sh`
#source /home/${USER}/.local/bin/virtualenvwrapper.sh
export WORKON_HOME=${BASE_DISK_MOUNT}/Envs
if [ ! -d $WORKON_HOME ]; then
    mkdir -p $WORKON_HOME
fi
EOF
}
if [ "`cat $HOME/.bashrc | grep -i virtual`" = "" ]; then
    #if [ "$WORKON_HOME" != "" ]; then
    setup_virtualenvwrapper_in_bashrc
fi

# To create & activate your default venv environment, say, "${PROJECT_HOME}"
echo "------"
unset PYTHONPATH
mkvirtualenv ${PROJECT_HOME}
workon ${PROJECT_HOME}

