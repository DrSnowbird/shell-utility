#!/bin/bash 
  
VENV_PROJ=${1:-my_venv}

if [ $# -lt 1 ]; then
    echo "Need project directory name for creating venv... Abort now!"
    echo "---- Usage-1: "
    echo "    source $(basename $0) <venv_proj_name> "
    echo "---- Usage-2: (assuming you install virtualenvwrapper and virutalenv)"
    echo "    mkvirtualenv ${VENV_PROJ}"
    echo "    workon ${VENV_PROJ}"
    exit 1
fi

VENV_PROJECT_HOME=~/Envs

export VIRTUALENVWRAPPER_PYTHON=${PYTHON_EXE}
source ${VIRTUALENVWRAPPER_SHELL}
export WORKON_HOME=${VENV_PROJECT_HOME}
if [ ! -d $WORKON_HOME ]; then
    mkdir -p $WORKON_HOME
fi

#### ---- Detect Python3 is installed ---- ####
PYTHON_VERSION=3
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

#########################################################################
#### ---- Customization for multiple virtual python environment ---- ####
#########################################################################
export VIRTUALENVWRAPPER_PYTHON=${PYTHON_EXE}
source ${VIRTUALENVWRAPPER_SHELL}
export WORKON_HOME=${VENV_PROJECT_HOME}
if [ ! -d $WORKON_HOME ]; then
    mkdir -p $WORKON_HOME
fi

# To create & activate your default venv environment, say, "${VENV_PROJ}"
echo "------"
mkvirtualenv ${VENV_PROJ}
workon ${VENV_PROJ}

