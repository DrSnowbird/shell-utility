#!/bin/bash -x

VAGRANT_VERSION=2.2.5

#### ---- Download debian package ----
## https://releases.hashicorp.com/vagrant/2.2.5/vagrant_2.2.5_x86_64.deb
wget -q -c https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_x86_64.deb

#### ---- Install debian package ----
# sudo dpkg -i ./vagrant_${VAGRANT_VERSION}_x86_64.deb
sudo apt install -y ./vagrant_${VAGRANT_VERSION}_x86_64.deb

#### ---- Clean up debian package ----
rm -f vagrant_${VAGRANT_VERSION}_x86_64.deb
