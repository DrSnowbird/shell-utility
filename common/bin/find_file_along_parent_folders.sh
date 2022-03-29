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
#TARGET_FILE=${1}
#START_PATH=${2:-./}
#START_PATH=$(realpath ${START_PATH})
FOUND_DIR=
function find_file_up_along_parent_folders() {
    FOUND_DIR=
    #TARGET_FILE=${1:-$TARGET_FILE}
    #PARENT=${2:-$START_PATH}
    _TARGET_FILE=${1}
    _START_PATH=${2}
    PARENT=${_START_PATH}
    if [ "${_TARGET_FILE}" == "" ] || [ "${_START_PATH}" == "" ]; then
        echo -e ">>> ERROR needs TARGET_FILE: ${_TARGET_FILE} as argument! Abort!"
        exit 1
    fi
    CONT=1
    while [ $CONT -gt 0 ] && [ "${PARENT}" != "/" ]; do
        echo ">>> dir=${PARENT}"
        if [ -s ${PARENT}/${_TARGET_FILE} ]; then
            echo -e ">>> YES: found TARGET_FILE: ${PARENT}/${_TARGET_FILE} "
            echo -e ">>> YES: found at FOLDER: ${PARENT}"
            FOUND_DIR=${PARENT}
            CONT=0 
        fi                   
        PARENT=$(dirname ${PARENT})
    done
}
find_file_up_along_parent_folders ${TARGET_FILE} ${START_PATH}
echo -e ">>> FOUND: \n    PARENT Folder: ${FOUND_DIR} \n    containing: TARGET_FILE: ${TARGET_FILE}"

#function find_file_up_along_parent_folders() {
#    FOUND_DIR=
#    PARENT=${START_PATH}
#    CONT=1
#    while [ $CONT -gt 0 ] && [ "${PARENT}" != "/" ]; do
#        echo ">>> dir=${PARENT}"
#        if [ -s ${PARENT}/${TARGET_FILE} ]; then
#            echo -e ">>> YES: found $PARENT/${TARGET_FILE} "
#            FOUND_DIR=${PARENT}
#            CONT=0 
#        fi                   
#        PARENT=$(dirname ${PARENT})
#    done
#}

