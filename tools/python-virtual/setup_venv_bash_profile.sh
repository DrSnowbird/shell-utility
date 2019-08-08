#!/bin/bash -x

VENV_PROJECT_HOME=~/Envs
PYTHON_VERSION=3

###########################################################################
#### ---------------------- DON'T CHANGE BELOW ----------------------- ####
###########################################################################
VENV_SETUP=`cat ~/.bashrc | VIRTUALENVWRAPPER_PYTHON`
if [ ! "${VENV_SETUP}" = "" ]; then
    echo ".. virtualenvwrapper alreay has been setup!"
    exit 0
fi

#### ---- Detect Python3 is installed ---- ####
PYTHON_EXE=`which python${PYTHON_VERSION}`
if [ "${PYTHON_EXE}" = "" ]; then
    echo "**** ERROR: Can't find ${PYTHON_EXE} ! .. Abort setup!"
    exit 1
fi

#### ---- Detect virtualenvwrapper is installed ---- ####
VIRTUALENVWRAPPER_SHELL=`which virtualenvwrapper.sh`
if [ "${VIRTUALENVWRAPPER_SHELL}" = "" ]; then
    echo "**** ERROR: Can't find virtualenvwrapper.sh script! .. Abort setup!"
    exit 1
fi

#### ---- Setup User's HOME profile to run virutalenvwrapper shell script ---

cat <EOF >>- ~/.bashrc

#########################################################################
#### ---- Customization for multiple virtual python environment ---- ####
####      (most recommended approach and simple to switch venv)      ####
#########################################################################
export VIRTUALENVWRAPPER_PYTHON=${PYTHON_EXE}
source ${VIRTUALENVWRAPPER_SHELL}
export WORKON_HOME=${VENV_PROJECT_HOME}
if [ ! -d $WORKON_HOME ]; then
    mkdir -p $WORKON_HOME
fi

EOF
