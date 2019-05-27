#!/bin/bash 

# MAINTAINER DrSnowbird "DrSnowbird@openkbs.org"

set -e

if [ $# -lt 2 ]; then
    echo "----------------------------------------"
    echo "---- Usage: Linux/CentOS SFTP Setup ----"
    echo "----------------------------------------"
    echo "    $(basename $0) <USER_NAME> <USER_PASSWD>"
    echo "----------------------------------------"
    echo "**** Abort! Need two arguments ****"
    echo "----------------------------------------"
    exit 1
fi

USER_NAME=${1:-mysftpuser}
USER_PASSWD=${2:-mypassword!}

sudo mkdir -p /data/${USER_NAME}/upload
sudo chmod 701 /data
sudo ls -ld $(sudo find /data)
sudo groudadd sftpusers

## -- Create a new SFTP user: --
# sudo passwd ${USER_NAME}
sudo useradd -g sftpusers -d /upload -s /sbin/nologin ${USER_NAME} -p $(echo ${USER_PASSWD} | openssl passwd -1 -stdin)
## -- Verify USER_NAME is created correctly with nologin allowed --
sudo cat /etc/passwd | grep ${USER_NAME}

## -- Setup owners properly --
sudo chown -R root:sftpusers /data/${USER_NAME}
sudo chown -R ${USER_NAME}:sftpusers /data/${USER_NAME}/upload
sudo ls -al $(sudo find /data)

## sudo vi /etc/ssh/sshd_config
DONE_SSHD_CONFIG="`sudo cat /etc/ssh/sshd_config|grep sftpusers`"
if [ "$DONE_SSHD_CONFIG" = "" ]; then
    sudo cp --backup=numbered /etc/ssh/sshd_config
cat <<EOF| sudo tee -a /etc/ssh/sshd_config
Match Group sftpusers
ChrootDirectory /data/%u
ForceCommand internal-sftp
EOF
else
    echo "---- INFO: Already update /etc/ssh/sshd_config setup for SFTP service! ----"
fi

sudo service sshd restart
sudo service sshd status

## -- Verify USER_NAME is created correctly with nologin allowed --
sudo touch /data/${USER_NAME}/upload/test_sftp.txt
sudo chown -R ${USER_NAME}:sftpusers /data/${USER_NAME}/upload
sudo ls -ld $(sudo find /data)

echo "------- DONE SFTP setup ------"
echo "To test: "
echo "    sftp ${USER_NAME}@`hostname -f` "
echo "------------------------------"

#### ---- Screen catpure of the results ----
# $ sudo ls -ld $(sudo find /data)
# drwx-----x. 4 root       root        36 Jan 15 11:01 /data
# drwxr-xr-x. 3 root       sftpusers   20 Jan 15 11:01 /data/mysftpuser
# drwxr-xr-x. 2 mysftpuser sftpusers  104 Jan 15 11:15 /data/mysftpuser/upload
# -rw-r--r--. 1 mysftpuser sftpusers    0 Jan 15 11:12 /data/mysftpuser/upload/test_sftp.txt
# drwxr-xr-x. 2 root       root         6 Jan 15 10:17 /data/sftp
