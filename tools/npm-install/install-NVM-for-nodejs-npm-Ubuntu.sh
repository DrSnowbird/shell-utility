#!/bin/bash -x

# ref: https://tecadmin.net/how-to-install-nvm-on-ubuntu-20-04/
sudo apt install curl 
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash 

# The nvm installer script creates environment entry to login script of the current user. You can either logout and login again to load the environment or execute the below command to do the same.

source ~/.bashrc

# Installing Node using NVM
### You can install multiple node.js versions using nvm. And use the required version for your application from installed node.js.

### Install the latest version of node.js. Here node is the alias for the latest version.
#### nvm install node 
### To install a specific version of node:
#### nvm install 12.18.3  

nvm install node

# -- Ubuntu use 'node' instead of nodejs: --
#nodejs --version
node --version
npm --version

