#!/bin/bash 

set -e

if [ $# -lt 1 ]; then
    echo "*** ERROR: need remote host name or ip to run this command! Abort now!"
    echo "--- Usage: $(basename $0) <Remote_hosts: seperated by comma no space> <Remote GIT Repo name>"
    echo "e.g."
    echo "./remote-git-update.sh \"host1,host2,host3,host1\" \"https://github.com/DrSnowbird/tensorflow-python3-jupyter.git\" "
    exit 1
fi

# Whether to overwrite local changes
OVERWRITE_LOCAL=1

# Change GIT_BASE if needed
GIT_BASE="~/git-public"

REMOTE_HOSTS="$1"

GIT_REPO=${2:-https://github.com/DrSnowbird/tensorflow-python3-jupyter.git}
REPO_NAME=`echo $(basename $GIT_REPO)|cut -d'.' -f1`

for h in `echo ${REMOTE_HOSTS}| tr '[,;]' ' ' `; do
    echo "================ Host: $h ================"  
    ssh -t ${h} << EOF
    cd ~/git-public/
    git ls-remote ${GIT_REPO} -q
    if [ $? -eq 0 ]; then
        echo "GIT ${GIT_REPO} already existing!"
    else
        echo "GIT ${GIT_REPO} - creating new local repo!"
        git clone ${GIT_REPO}
    fi
    cd ${GIT_BASE}/${REPO_NAME}
    sed -i 's#git\@github.com\:#https\:\/\/github.com\/#' ~/git-public/${REPO_NAME}/.git/config 
    if [ $OVERWRITE_LOCAL -eq 1 ]; then
        git checkout *
    fi
    git pull
    git status
    echo "====================================="
EOF
done
