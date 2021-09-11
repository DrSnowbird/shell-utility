#!/bin/bash -x

set -e

#### -------------------------------------------------- ####
#### Goals:
####     1. Use OS Drive for OS Only
####     2. Use Data (Hard/SSD) Drive for any APP's Data
####     3. So, we can rapidly change OS drive or
####     4. Also, we can move the Data Drive or Folders
####        from machine to machine to rapid migration!
####
#### Usage:
####     REMOTE_DISK: default= /mnt/data
####     DISK_BASE  : default= /mnt/data or $HOME
####     TOOLS_DIR  : default= $DISK_BASE/tools
#### 
#### Change:
####     Just change the above to match your need specifically!
####
#### -------------------------------------------------- ####
    
#### ---- Remote Disk (/mnt/data) available or not ---- ####
function setup_APP_RemoteDisk_Mapping() {
    REMOTE_DISK=/mnt/data
    DISK_BASE=${1:-${REMOTE_DISK}}
    if [ ! -s ${REMOTE_DISK} ]; then
        DISK_BASE=~
    else
        echo ln -s /mnt/data ~/$(basename ${REMOTE_DISK})
    fi
    
    #### ---- Setup: tools directory: ---- ####
    TOOLS_DIR=${DISK_BASE}/tools
    if [ ! -s ${TOOLS_DIR} ]; then
        echo "**** ERROR: missing ${TOOLS_DIR} directory for target APP installation directory! Abort"
        exit 1
    fi
    
    #### ---- Setup: Soft-Links at HOME: ---- ####
    APP_DIRS="Downloads git-public data-docker"
    if [ ! -s ${TOOLS_DIR} ]; then
        echo "**** ERROR: Can't continue: Missing TOOLS_DIR: ${TOOLS_DIR}"
        exit 1
    else
        ## -- OK, TOOLS_DIR existing: -- ##
	for app_dir in ${APP_DIRS}; do
    	echo "--------- app_dir: $app_dir ----------"
            if [ ! -s ${REMOTE_DISK}/${app_dir} ]; then
    	    mkdir -p ${REMOTE_DISK}/${app_dir}
    	else
    	    echo "---- INFO: FOUND: ${REMOTE_DISK}/${app_dir} "
    	fi
    	echo ".... Remove old soft-link: ~/${app_dir}"
    	rm -f ~/${app_dir}
    	echo ".... Creating soft-link: ln -s ${REMOTE_DISK}/${app_dir} ~/${app_dir} "
        ln -s ${REMOTE_DISK}/${app_dir} ~/${app_dir}
    	ls -al ~/${app_dir}
        done
    
    fi
}
setup_APP_RemoteDisk_Mapping

#### ---- Docker (/var/lib/docker) Remote Disk (/mnt/data) mapping: ---- ####
function setup_Docker_RemoteDisk_Mapping() {
    REMOTE_DISK=/mnt/data
    DISK_BASE=${1:-${REMOTE_DISK}}
    DOCKER_NAME=docker
    if [ ! -s ${REMOTE_DISK} ]; then
        DISK_BASE=/var/lib
	    echo "**** ${REMOTE_DISK} not available! Do nothing"
	    exit 0
    else
        #### ---- Setup: /var/lib/docker to Remote Docker Soft-Links : ---- ####
        DOCKER_DIR=/var/lib/${DOCKER_NAME}
        DOCKER_DIR_REMOTE=${DISK_BASE}/${DOCKER_NAME}
        
        echo "---- 1. Save current /var/lib/docker in case we need it"
        if [ -s ${DOCKER_DIR} ]; then
            echo "---- INFO: FOUND Existing Docker: ${DOCKER_DIR}"
	        SAVED_DOCKER_DIR=${DOCKER_DIR}.`date "+%Y-%M-%d"`
	        echo ".... SAVE existing ${SAVED_DOCKER_DIR}"
	        echo mv ${DOCKER_DIR} ${SAVED_DOCKER_DIR}
        fi
        
        echo "---- 2. Prepare remote Docker directory: ${DOCKER_DIR_REMOTE}"
        if [ ! -s ${DOCKER_DIR_REMOTE} ]; then
            echo "---- INFO: To create DOCKER_DIR_REMOTE directory: ${DOCKER_DIR_REMOTE}="
            sudo mkdir -p ${DOCKER_DIR_REMOTE}
	    fi
        #echo sudo chown -R root:root ${DOCKER_DIR_REMOTE}
        sudo chmod -R 0711 ${DOCKER_DIR_REMOTE}
	    
	    echo "---- 3. Create soft-link: ${DOCKER_DIR} -> ${DOCKER_DIR_REMOTE}"
        sudo ln -s ${DOCKER_DIR_REMOTE} ${DOCKER_DIR}
	    sudo ls -al ${DOCKER_DIR_REMOTE} ${DOCKER_DIR}
    fi
}
#setup_Docker_RemoteDisk_Mapping

