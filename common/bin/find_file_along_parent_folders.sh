#!/bin/bash 

TARGET_FILE=${1}
START_PATH=${2:-./}
START_PATH=$(realpath ${START_PATH})

function usage() {
    echo "---- Usage: ----"
    echo " $(basename $0) <TARGET_FILE_PATH, e.g., ./python-nonroot-docker/scripts/printVersions.sh> "
    echo " find_file_along_parent_folders.sh bin/auto-config-with-template.sh ./scripts/"
    echo
}

if [ $# -lt 1 ]; then
    echo -e ">>> *** ERROR: Need TARGET_FILE as argument! Abort"
    usage
    exit 1
else
    echo -e ">>> TARGET_FILE=${TARGET_FILE}"
fi

# example " find_file_along_parent_folders.sh bin/auto-config-with-template.sh ./scripts/"
FOUND_DIR=
function find_file_up_along_parent_folders() {
    FOUND_DIR=
    PARENT=${START_PATH}
    CONT=1
    while [ $CONT -gt 0 ] && [ "${PARENT}" != "/" ]; do
        echo ">>> dir=${PARENT}"
        if [ -s ${PARENT}/${TARGET_FILE} ]; then
            echo -e ">>> YES: found $PARENT/${TARGET_FILE} "
            FOUND_DIR=${PARENT}
            CONT=0 
        fi                   
        PARENT=$(dirname ${PARENT})
    done
}
find_file_up_along_parent_folders

