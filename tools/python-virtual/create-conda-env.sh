#!/bin/bash
  
MYENV=${1:-orca}
if [ $# -lt 1 ]; then
    echo ">>> ERROR: Usage: $1 <conda_ENV_name> [<python_version, e.g.: 3.9, 3.10, 3.11 etc.>]"
    echo "... Please try again!"
    exit 1
fi

PYTHON_VER=3.11
CURR_DIR=`pwd`

## -- Prompt users for continuing or not: -- ##
wait_seconds=10
CONT_YES=0
#CONT_YES=1
function askToContinue() {
    PROMPT=${1:-"Are you sure to continue (Yes/No) or CTRL-C to abort this operaiton... ?"}
    read -t $wait_seconds -p "$PROMPT" -n 1 -r
    #read -p "Are you sure to continue (Yes/No)?" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo ".... do dangerous stuff ..."
    else
        echo ".... cancel ..."
        CONT_YES=0
        exit 0
    fi
}
askToContinue

## -- Create Conda ENV: -- ##
# CONDA3_HOME=~/anaconda3/
# ~/anaconda3/envs/orca
if [ -s $CONDA3_HOME/envs/${MYENV} ]; then
    echo "... Already exists Conda ENV: ${MYENV} ..."
else
    echo ">>> Need to create Conda env: ${MYENV} in ~/ENV/${MYENV} ..."
    conda create --name ${MYENV} -c conda-forge python=${PYTHON_VER}
fi
echo "... To acticate Conda env: conda activate ${MYENV} "
conda activate ${MYENV}

cd ${CURR_DIR}

