#!/bin/bash -x

BASE_DISK_MOUNT=/mnt/seagate-3tb

ROOT_DIR=${BASE_DISK_MOUNT}/git-public

#mkdir -p ${ROOT_DIR}

if [ ! -d ${ROOT_DIR} ]; then
    echo "${ROOT_DIR} not found! Cant' continue! Abort! "
    exit 1
fi


#### ---- Install git ---- ####
function install_git() {
    sudo apt install -y git meld
    USER_EMAIL=${USER}@openkbs.org
    USER_NAME=DrSnowbird
    git config --global user.email "${USER_EMAIL}"
    git config --global user.name "${USER_NAME}"
    if [ ! -d ${ROOT_DIR}/shell-utility ]; then
        cd ${ROOT_DIR}
        git clone git@github.com:DrSnowbird/shell-utility.git
    fi
}
if [ "`which git`" = "" ]; then
    install_git
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

#### ---- Setup Aliases---- ####
function setup_aliases() {
    alias_setup_already="`cat ~/.bashrc | grep git-alias.sh`"
    if [ "$alias_setup_already" = "" ]; then
        cat << EOF >> ~/.bashrc
        
#### ---- Customized aliases ----
####

. ~/bin/git-alias.sh
. ~/bin/docker-alias.sh

export JAVA_HOME=/usr/lib/jvm/default-java
export PATH=\${JAVA_HOME}:\${PATH}

EOF
    else
	    echo "..... setup_aliases(): already being set up!"
    fi

    if [ ! -s ~/bin/git-alias.sh ]; then
        cd ${ROOT_DIR}/shell-utility/initial-setup/alias
        mkdir -p ~/bin
        cp git-alias.sh ~/bin
        cp docker-alias.sh ~/bin
        cd
        chmod +x ~/bin/*.sh
        source ~/.bashrc
        env
    else
        echo "*** ERROR: can't find ~/bin/git-alias.sh! Abort!"
    fi
    alias
}
setup_aliases

