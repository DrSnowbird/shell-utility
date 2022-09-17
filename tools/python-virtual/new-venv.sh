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

# To create & activate your default venv environment, say, "${PROJECT_HOME}"
echo "------"

VENV_NAME=$(basename ${PROJECT_HOME})
VENV_DIR=$(dirname ${PROJECT_HOME})

mkvirtualenv ${VENV_NAME}
workon ${VENV_NAME}

