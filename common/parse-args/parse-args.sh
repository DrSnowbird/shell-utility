#!/bin/bash 

# ------------------------------------ 
# maintainer: DrSnowbird@openkbs.org
# license: Apache License Version 2.0
# ------------------------------------ 

ORIG_ARGS="$*"

#### ---- Usage ---- ####
function usage() {
    echo "-------------- Usage --------------"
    echo "SHORT=ho:"
    echo "LONG=help,output:"
    echo "-----------------------------------"
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

SHORT="ho:"
LONG="help,output:"

#PARSED=$(getopt --options ${SHORT} --longoptions ${LONG} --name "$0" -a -- "$@")
PARSED=$(getopt -o ${SHORT} -l ${LONG} --name "$0" -a -- "$@")

if [[ $? != 0 ]]; then
    echo "Parsing Error! Abort!"
    exit 1
fi
eval set -- "${PARSED}"

while true
do
    case "$1" in
        -h|--help)
            usage
            ;;
        -o|--output)
            shift
            OUTPUT_FILE=$1
            echo "OUTPUT_FILE=$OUTPUT_FILE"
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "*****: input args error"
            echo "$ORIG_ARGS"
            exit 3
            ;;
    esac
    shift
done

echo "-------------"
echo "ORIGINAL INPUT >>>>>>>>>>:"
echo "${ORIG_ARGS}"

echo "-------------"
echo "After Parsing: INPUT >>>>>>>>>>:"
echo "$@"

#### ---------------
#### ---- MAIN: ----
#### ---------------

echo "..... Start your main code here .............."

