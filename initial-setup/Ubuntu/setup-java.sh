#!/bin/bash -x

BASE_DISK_MOUNT=$HOME
if [ -s /mnt/seagate-3tb/ ]; then
    BASE_DISK_MOUNT=/mnt/seagate-3tb/
fi

GIT_DIR=${BASE_DISK_MOUNT}/git-public

#### ---- OpenJDK setup ---- ####
function java_install() {
    if [ -d ${GIT_DIR}/shell-utility/tools/java-install ]; then
        cd ${GIT_DIR}/shell-utility/tools/java-install
        ./install-java-Ubuntu-OpenJDK.sh
        # latest JDK 11 as default from Ubuntu 20
        # ./install-java-Ubuntu-OpenJDK.sh
    fi
    java -version
}
#if [ "`which java`" = "" ]; then
#    java_install
#fi
java_install

