#!/bin/bash -x
cat <<EOF| sudo tee -a ./sshd_config
Match Group sftpusers
ChrootDirectory /data/%u
ForceCommand internal-sftp
EOF
