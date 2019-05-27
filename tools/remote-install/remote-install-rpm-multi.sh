#!/bin/bash 

set -e

if [ $# -lt 1 ]; then
    echo "*** ERROR: need remote host name or ip to run this command! Abort now!"
    echo "--- Usage: $(basename $0) <Remote_hosts: seperated by comma no space> <URL to download RPM package>"
    exit 1
fi

REMOTE_HOSTS="$1"
RPM_URL=${2:-http://download-ib01.fedoraproject.org/pub/epel/7/x86_64/Packages/m/meld-3.16.4-2.el7.noarch.rpm}

for h in `echo ${REMOTE_HOSTS}| sed 's/,/ /'`; do
  ssh -t ${h} << EOF
  wget ${RPM_URL}
  sudo yum install patch -y
  sudo rpm -Uvh $(basename $RPM_URL)
EOF
done
