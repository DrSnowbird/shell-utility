#!/bin/sh
LOCAL_DIR=${HOME}/Share
USER_NAME=${LOGNAME}

# --- Map /home/${LOGNAME}/Share to /media/sf_D_DRIVE for soft-link:
# --- D_DRIVE on /media/sf_D_DRIVE type vboxsf (gid=999,rw)
echo "--- Map /home/${LOGNAME}/Share to /media/sf_D_DRIVE for soft-link"
VBOX_MOUNT_SF_DRIVE=`mount | grep vboxsf | cut -d" " -f3`
if [ "${VBOX_MOUNT_SF_DRIVE}" == "" ]; then
    echo "ERROR: --- NO SHARE DRIVE is detected! ---"
    exit ;
else
    echo "SUCCESS: --- SHARE DRIVE is detected! ---"
    echo ${VBOX_MOUNT_SF_DRIVE}
fi

# --- add ${USER_NAME} into 'vboxsf' group: to allow access Share Drive
sudo usermod -a -G vboxsf ${USER_NAME}

# --- Remove old link and create a new link: ---
rm ${LOCAL_DIR}
echo "ln -s ${VBOX_MOUNT_SF_DRIVE} ${LOCAL_DIR}"
ln -s ${VBOX_MOUNT_SF_DRIVE} ${LOCAL_DIR}

# --- You need to log out to active the permission: ---
cd ${HOME}
echo "You need to log out and login again to activate permission."

