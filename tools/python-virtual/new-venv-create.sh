#!/bin/bash 

echo "#######################################"
echo "#### Preferred to use virtualenvwrapper"
echo "#### --> See README.md"
echo "#######################################"

echo "Continue?"
read -p "Are you sure to continue (NOT Recommended!) ? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff
else
    exit 0
fi

# virtualenv vs venv
#   https://stackoverflow.com/questions/41573587/what-is-the-difference-between-venv-pyvenv-pyenv-virtualenv-virtualenvwrappe
# Install latest Python 3.7: 
#   http://ubuntuhandbook.org/index.php/2019/02/install-python-3-7-ubuntu-18-04/

## -- default --
PYTHON_VERSION=3.6

echo "... existing Python versions: ..."
# ls /usr/bin/python* | egrep -e "python([2-3](\.[0-9])?)*"
ls /usr/bin/python* | grep -v "config"

echo 

if [ $# -lt 1 ]; then
    echo "=== Usage: ==="
    echo "$(basename $0) <new_venv_directory_path> [<Python version: 3, 3.5, 3.6, 3.7, (default=3.6) >]"
    exit 1
fi

PYTHON_VERSION=${2:-$PYTHON_VERSION}
if [ "`which python${PYTHON_VERSION}`" = "" ]; then
    echo "echo **** ERROR ****: python${PYTHON_VERSION} doesn't exist! "
    exit 2
fi 

# reset/clean up already-set Python vars
export PYTHONPATH=

VENV_DIR=${1}
if [ ! -d $(dirname ${VENV_DIR}) ]; then
    mkdir -p $(dirname ${VENV_DIR})
fi
virtualenv -p `which python${PYTHON_VERSION}` ${VENV_DIR}

ls -al ${VENV_DIR}
echo ""
echo "-------------------------------------------------"
echo ">>> Now, to activate: do the following two steps:"
echo "    cd ${VENV_DIR}"
echo "    source bin/activate"
echo ">>> To de-activate: run the freeze command:"
echo "    deactivate"
echo "-------------------------------------------------"
