#!/bin/bash -x

set -e

PROG_NAME=$(basename $0)

# --docker_base_dir git-public
APP_ROOT=/home/$USER/git-public

# --app_name tensorflow-pythong3-jupyter
APP_NAME=tensorflow-python3-jupyter

# --app_command start / stop
APP_CMD=start
#APP_CMD=stop

# ------------------------------------ 
# maintainer: DrSnowbird@openkbs.org
# license: Apache License Version 2.0
# ------------------------------------ 

ORIG_ARGS="$*"

#### ---- Usage ---- ####
function usage() {
    echo "--- Usage: $(basename $0) <Remote_hosts: seperated by comma> <APP_NAME> <APP_CMD: start/stop> "
    echo "e.g."
    echo "./${PROG_NAME}  --HOSTS \"host1,host2,host3,host1\" --APP_ROOT ~/git-public --APP_NAME tensorflow-python3-jupyter --APP_CMD start "
    echo "./${PROG_NAME}  -H \"host1,host2,host3,host1\" -R ~/git-public -A tensorflow-python3-jupyter -C start "
    echo
    echo "./${PROG_NAME}  -h  (for help)"
    echo "./${PROG_NAME}  -help  (for help)"
    echo "-----------------------------------"
}

if [ $# -lt 3 ]; then
    echo "**** ERROR: Requiring 3 arguments to run! ****"
    usage
    exit 1
fi

SHORT="hH:R:A:C:"
LONG="help,HOSTS:,APP_ROOT:,APP_NAME:,APP_CMD:"

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
        -H|--HOSTS)
            shift
            HOSTS=$1
            echo "HOSTS=$HOSTS"
            ;;
        -R|--APP_ROOT)
            shift
            APP_ROOT=$1
            echo "APP_ROOT=$APP_ROOT"
            ;;
        -A|--APP_NAME)
            shift
            APP_NAME=$1
            echo "APP_NAME=$APP_NAME"
            ;;
        -C|--APP_CMD)
            shift
            APP_CMD=$1
            echo "APP_CMD=$APP_CMD"
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

# Change GIT_BASE if needed
GIT_BASE="~/git-public"

for h in `echo ${HOSTS}| tr '[,;]' ' ' `; do
    echo "================ Host: $h ================"  
    ssh -t ${h} << EOF
    cd ${GIT_BASE}/${APP_NAME}
    git pull
    git status
   
    # ---- Pull latest docker image ---- 
    sudo docker pull openkbs/${APP_NAME}
    if [ "${APP_CMD}" = "start" ]; then
        ./run.sh
        sudo docker ps |grep -i ${APP_NAME}
    else
        if [ "${APP_CMD}" = "stop" ]; then
            ./stop.sh
            sudo docker ps |grep -i ${APP_NAME}
        fi 
    fi
    echo "====================================="
EOF
done
