#!/bin/bash -x

#########################################################################
#### ---- Customization for multiple virtual python environment ---- ####
#########################################################################

export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
#source /home/$USER/.local/bin/virtualenvwrapper.sh
#export WORKON_HOME=~/Envs
export WORKON_HOME=/mnt/seagate-3tb/Envs
if [ ! -d $WORKON_HOME ]; then
    mkdir -p $WORKON_HOME
fi

