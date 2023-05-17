#!/bin/bash -x

## source:
##    https://askubuntu.com/questions/1403741/ubuntu-22-04-cant-suspend

sudo systemctl disable nvidia-hibernate.service nvidia-resume.service nvidia-suspend.service

echo -e ">>> ... "
echo -e ">>> You can now test Suspend to see if it works for Ubuntu 22.04 ..."
echo -e ">>> ..."

