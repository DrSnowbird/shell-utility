#!/bin/bash

# --------------------------------------------------------
# VirtualBox Share Drive,name, 
#     "D_DRIVE"
#
# In VirtualBox Shared Folder: 
#     "Auto-mount", "Mount Permanently"
# --------------------------------------------------------
SHARED_FOLDER=${HOME}/Share
USER_LOGIN=${USER}

echo "*** Make sure that you DON'T use SUDO to start this command! ***"
date ; read -p "Hit ENTER to continue ..."

# --------------------------------------------------------
# Mount external System Drive, "D_Drive"
# Link (soft) the newly mounted "D_Drive" with "SHARED_FOLDER"
# --------------------------------------------------------
# D_DRIVE on /media/sf_D_DRIVE type vboxsf (gid=999,rw)
# sudo mount -t vboxsf -o uid=1000,gid=1000 ${SHARE_DRIVE} ${MOUNT_DIR}
VBOX_MOUNT_SF_DRIVE=`mount | grep vboxsf | cut -d" " -f3`
if [ -f ${VBOX_MOUNT_SF_DRIVE} ]
then
    echo "ERROR: *** NO SHARE DRIVE exists! Or, it is NOT detected! ***"
    exit -1
else
    echo "SUCCESS: --- SHARE DRIVE is detected! ----:"
    echo ${VBOX_MOUNT_SF_DRIVE}
fi
# Change Access permission
sudo usermod -a -G vboxsf ${USER_LOGIN}

cd ${HOME}
ln -s ${VBOX_MOUNT_SF_DRIVE} ${SHARED_FOLDER}
echo "You need to log out and login again to activate permission."




