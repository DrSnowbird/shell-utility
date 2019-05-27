#!/bin/bash

GIT_REPO_PATH=${1}

#### Note: the version extracted will remove the prefix "v" from, e.g., v3.11.0 to be 3.11.0

if [ $# -lt 1 ]; then
    echo "*** ERROR: --- Usage ----"
    echo "    $(base name $0) <GIT-REPO-PATH>"
    echo "e.g."
    echo "    $(base name $0) minishift/minishift "
    echo "    $(base name $0) DrSnowbird/eclipse-photon-docker "

    exit 1
fi

LATEST_VERSION=

USE_GIT_API=0

##############################################
#### ---- Using curl, grep, sed only ---- ####
##############################################
function get_latest_release() {
    TGZ_URL=`curl --silent https://github.com/${1}/releases |grep "tar.gz" |head -1|cut -d'"' -f2`
    # TGZ_URL=`curl https://github.com/openshift/origin/releases |grep "client-tools"|grep "tar.gz" |head -1|cut -d'"' -f2`
    # https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz

    LATEST_VERSION=`echo $(basename ${TGZ_URL}) | sed -E 's/.*v([^-]+).*/\1/' `
    LATEST_VERSION=${LATEST_VERSION%%.tar.gz}
}
get_latest_release ${GIT_REPO_PATH}

##############################################
#### ---- Using curl, grep, sed only ---- ####
##############################################
function get_latest_release_api() {
    LATEST_VERSION=`curl --silent "https://api.github.com/repos/${1}/releases/latest" | # Get latest release from GitHub api
    grep '"tag_name":'  |                                             # Get tag line
    sed -E 's/.*"v([^"]+)".*/\1/' `                                   # Pluck JSON value
}

##############################################
#### ---- Using curl, jq(json), sed ##########
##############################################
function get_latest_release_api_jq() {
    curl --silent "https://api.github.com/repos/${1}/releases/latest" | jq -r '.tag_name'
    LATEST_VERSION=`curl --silent "https://api.github.com/repos/${1}/releases/latest" | jq -r .tag_name | sed 's/^v//' `
}

if [ $USE_GIT_API -gt 0 ]; then
    if [ `which jq` ]; then
        echo "---- jq found! ----"
        get_latest_release_api_jq ${GIT_REPO_PATH}
    else
        echo "**** No jq found! ****"
        get_latest_release ${GIT_REPO_PATH}
    fi 
else 
    get_latest_release ${GIT_REPO_PATH}
fi

echo "LATEST_VERSION=${LATEST_VERSION}"

