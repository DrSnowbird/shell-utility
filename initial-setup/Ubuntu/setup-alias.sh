#!/bin/bash -x

BASE_DISK_MOUNT=$HOME
if [ -s /mnt/seagate-3tb/ ]; then
    BASE_DISK_MOUNT=/mnt/seagate-3tb/
fi

GIT_DIR=${BASE_DISK_MOUNT}/git-public

function customize_local_bin_to_use_shell_utility() {
    cp ${GIT_DIR}/shell-utility/docker/bin/* $HOME/bin/
    cp ${GIT_DIR}/shell-utility/common/bin/* $HOME/bin/
}
customize_local_bin_to_use_shell_utility
