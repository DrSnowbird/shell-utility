#!/bin/bash 

set -e

if [ $# -lt 1 ]; then
    echo "*** ERROR: need remote host name or ip to run this command! Abort now!"
    exit 1
fi

REMOTE_HOST=$1
RPM_URL=${2:-http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/m/meld-3.16.4-2.el7.noarch.rpm}

ssh ${REMOTE_HOST} wget ${RPM_URL}
ssh ${REMOTE_HOST} sudo yum install patch -y
ssh ${REMOTE_HOST} sudo rpm -Uvh *rpm
