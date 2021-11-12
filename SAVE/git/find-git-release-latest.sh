#!/bin/bash -x

GIT_PATH=${1}

tmp_git=${GIT_PATH%.git}
# https://github.com/cdr/code-server.git
# git@github.com:cdr/code-server.git
REPO_NAME=${tmp_git#*github.com?}

## compressed file type: "tar.gz", "tgz", "zip", etc.
COMPRESSED_FILE_TYPE=${2}
#### Note: the version extracted will remove the prefix "v" from, e.g., v3.11.0 to be 3.11.0

if [ $# -lt 1 ]; then
    echo "*** ERROR: --- Usage ----"
    echo "    $(basename $0) <REPO_NAME> [<COMPRESSED_FILE_TYPE: default tar.gz; can be, xz, tgz, etc.> ]"
    echo "e.g."
    echo "    $(basename $0) minishift/minishift "
    echo "    $(basename $0) DrSnowbird/eclipse-photon-docker "
    echo "    $(basename $0) cdr/code-server.git"
    echo "    $(basename $0) https://github.com/cdr/code-server.git"
    echo "    $(basename $0) git@github.com:cdr/code-server.git"
    exit 1
fi

LATEST_VERSION=

USE_GIT_API=0

##############################################
#### ---- Using curl, grep, sed only ---- ####
##############################################
function get_latest_release() {
    curl https://github.com/${REPO_NAME}/releases/latest
    TGZ_URL=`curl --silent https://github.com/${REPO_NAME}/releases/latest |grep "${COMPRESSED_FILE_TYPE}" |head -1|cut -d'"' -f2`
    # TGZ_URL=`curl https://github.com/openshift/origin/releases |grep "client-tools"|grep "tar.gz" |head -1|cut -d'"' -f2`
    # https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

    LATEST_VERSION=`echo $(basename ${TGZ_URL}) | sed -E 's/.*v([^-]+).*/\1/' `
    LATEST_VERSION=${LATEST_VERSION%%.$COMPRESSED_FILE_TYPE}
}
get_latest_release ${REPO_NAME}

##############################################
#### ---- Using curl, grep, sed only ---- ####
##############################################
function get_latest_release_api() {
    LATEST_VERSION=`curl --silent "https://api.github.com/repos/${REPO_NAME}/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":'  |                                             # Get tag line
    sed -E 's/.*"v([^"]+)".*/\1/' `                                   # Pluck JSON value
}

function get_latest_release_tomcat() {
    LATEST_VERSION=`curl --silent https://rdf4j.org/download/ 2>&1 | grep "(latest)" | head -n 1 | awk '{print $2}'`
}

##############################################
#### ---- Using curl, jq(json), sed ##########
##############################################
function get_latest_release_api_jq() {
    curl --silent "https://api.github.com/repos/${REPO_NAME}/releases/latest" | jq -r '.tag_name'
    LATEST_VERSION=`curl --silent "https://api.github.com/repos/${REPO_NAME}/releases/latest" | jq -r .tag_name | sed 's/^v//' `
}

if [ $USE_GIT_API -gt 0 ]; then
    if [ `which jq` ]; then
        echo "---- jq found! ----"
        get_latest_release_api_jq ${REPO_NAME}
    else
        echo "**** No jq found! ****"
        get_latest_release_api ${REPO_NAME}
    fi 
else
    get_latest_release ${REPO_NAME}
fi

echo "LATEST_VERSION=${LATEST_VERSION}"

