#!/bin/bash 

SOURCE_FILE=$1
if [ "$1" == "" ] || [ ! -s $1 ]; then
    echo -e ">> ERROR: Usage:"
    echo -e "  $0 <SOURCE_FILE> [<DESTINATION_ROOT_DIR>:- ./ ]"
    exit 1
fi

BASE_FILENAME=$(basename ${SOURCE_FILE})
DESTINATION_ROOT_DIR=./

TARGET_FILES=`ls $(find ${DESTINATION_ROOT_DIR}  -name "${BASE_FILENAME}") `
for f in ${TARGET_FILES}; do
    if [ "${f}" != "${SOURCE_FILE}" ]; then
        echo -e "cp ${SOURCE_FILE} ${f}"
    else
        echo -e "... skip: ${f}"
    fi
done
