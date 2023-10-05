#!/bin/bash 

PYTHON_VERSION=3

#### ---- Detect [python3] is installed ---- ####
#### common location: /usr/bin/python3
PYTHON_EXE=`which python${PYTHON_VERSION}`
if [ "${PYTHON_EXE}" = "" ]; then
    echo "**** ERROR: Can't find ${PYTHON_EXE} ! .. Abort setup!"
    exit 1
fi
echo -e ".. Python3: Found!: PYTHON_EXE=${PYTHON_EXE}"
echo

function install_intall_venv() {
    # sudo apt-get install python3 python3-dev python3-setuptools python3-pip
    sudo apt install -y python3-pip
    sudo pip3 install virtualenv
    sudo pip3 install virtualenvwrapper
    which virtualenvwrapper.sh
}

if [ "`which virtualenvwrapper.sh`" == "" ]; then
    echo ".. install_intall_venv"
    install_intall_venv
else
    echo "-- SUCCESS: Installed virtualenv & virtualenvwrapper!"
fi


###########################################################################
#### ---------------------- DON'T CHANGE BELOW ----------------------- ####
###########################################################################

#### ---- Detect [virtualenv] is installed ---- ####
#### common location: /usr/local/bin/vi:rtualenv
####
VIRTUALENV_EXE=`which virtualenv`
if [ "${VIRTUALENV_EXE}" = "" ]; then
    echo "** ERROR: Can't find virtualenv ! Abort!"
    exit 1
else
    echo -e ".. Found: virtualenv "
    echo
fi

#### ---- Detect [virtualenvwrapper] is installed ---- ####
#### common location: /usr/local/bin/virtualenvwrapper.sh
VIRTUALENVWRAPPER_SHELL=`which virtualenvwrapper.sh`
if [ "${VIRTUALENVWRAPPER_SHELL}" = "" ]; then
    echo "** ERROR: Can't find virtualenvwrapper ! Abort!"
    exit 1
else
    echo -e ".. Found: virtualenvwrapper "
    echo
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
source `which virtualenvwrapper.sh`
export WORKON_HOME=~/Envs
if [ ! -d $WORKON_HOME ]; then
    mkdir -p $WORKON_HOME
fi
EOF
}


#### ---- Detect setup .bashrc for virtualenv & virtualenvwrapper ---- ####
####
VENV_SETUP=`cat ~/.bashrc | grep -i virtual`
if [ ! "${VENV_SETUP}" = "" ]; then
    echo "--- Setup virtualenv in .bashrc before! Do nothging"
    exit 0
else
    setup_virtualenvwrapper_in_bashrc
    tail -12 ~/.bashrc
fi

echo -e "---------------------------------------"
echo -e "... To create virtualenv: "
echo -e "e.g."
echo -e "  mkvirtualenv yolov5 "

