#!/bin/bash 

################################ Usage #######################################
## --------------------------------------------------------------------------
## Usage: When run: ./replace-key-value-multiple-files.sh.sh try.conf KEY1 BBBBB
##
##   The result will on replace 
##   "KEY1   =  AAAAA" to 
##   "KEY1    = BBBBB"
##
## -- example file below ----
#### Comment line should be igored by parser for replacement (leave it alone!)
#### Parital (subsuming) matches should be ignored also
#### Blank space in between or front should be ignored.
#
# KEY1=1111
#    KEY123 = 123
#KEY1   =  AAAAA
## --------------------------------------------------------------------------

## -- main -- ##

set -e

TEMPLATE_FILE=".env.template"
CONFIG_FILES=$*
function usage() {
    if [ $# -lt 1 ]; then
        echo "**** ERROR: $(basename $0): Need at least one or more arguments: <FILE_1> <FILE_2> <FILE_3> ...>"
        echo "No configuration file provided: -- try using default ${TEMPLATE_FILE} instead"
        env_tempalte=`find ./../ -name "${TEMPLATE_FILE}"`
        if [ -s $env_tempalte ]; then 
            CONFIG_FILES=${env_tempalte}
            echo "... Found default ${TEMPLATE_FILE} ${env_tempalte} and it will be used!"
        else
            echo "**** ERROR: -- No existing ${TEMPLATE_FILE} found! Abort!"
            exit 1
        fi
    fi
}
usage $*

function replaceValueInConfig() {
    FILE=${1}
    KEY=${2}
    VALUE=${3}
    search=`cat $FILE|grep "$KEY"`
    if [ "$search" = "" ]; then
        echo "-- Not found: Append into the file"
        echo "$KEY=$VALUE" >> $FILE
    else
        sed -i 's/^[[:blank:]]*\('$KEY'[[:blank:]]*=\).*/\1'$VALUE'/g' $FILE
    fi
    echo "results (after replacement) with new value:"    
    cat $FILE |grep $KEY
}

#{{DUMMY_LOCAL_HOST_IP}}
#{{DUMMY_LOCAL_HOST_NAME}}

DUMMY_LOCAL_HOST_IP=`hostname -i`
DUMMY_LOCAL_HOST_NAME=`hostname -f`

files="$CONFIG_FILES"
for f in $files; do
    echo "=============== Generating config file from: $f =================="
    AUTO_GEN_FILE=${env_template%.*}.AUTO
    echo "...... AUTO_GEN_FILE= $AUTO_GEN_FILE"
    cp $f ${AUTO_GEN_FILE}
    sed -i "s#{{DUMMY_LOCAL_HOST_IP}}#$DUMMY_LOCAL_HOST_IP#g" ${AUTO_GEN_FILE}
    sed -i "s#{{DUMMY_LOCAL_HOST_NAME}}#$DUMMY_LOCAL_HOST_NAME#g" ${AUTO_GEN_FILE}
    cat ${AUTO_GEN_FILE}
    echo "-------------- Comparing template and auto-generated files: ----------"
    diff $f ${AUTO_GEN_FILE}
    echo "---- Auto-generated file: ${AUTO_GEN_FILE}"
done

