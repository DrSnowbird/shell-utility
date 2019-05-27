#!/bin/bash -x

# ref: https://linuxize.com/post/how-to-install-google-chrome-web-browser-on-centos-7/

cd $HOME

#### ---- Prepare libs to install Google Chrome ----
sudo rpm --import https://dl-ssl.google.com/linux/linux_signing_key.pub
sudo yum install redhat-lsb-core
sudo yum install -y epel-release
sudo yum install -y appindicator3 Xss
sudo yum install -y libXScrnSaver
sudo yum install -y libappindicator-gtk

#### ---- Now, install Google Chrome ----
CHROME_RPM_URL=https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
#wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
wget -c ${CHROME_RPM_URL}

#sudo yum localinstall google-chrome-stable_current_x86_64.rpm
sudo yum localinstall $(basename ${CHROME_RPM_URL})

cat /etc/yum.repos.d/google-chrome.repo

rm -f $(basename ${CHROME_RPM_URL})
