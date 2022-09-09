#!/bin/bash -x

# 1.) First, update your existing list of packages:

sudo apt update

# 2.) Next, install a few prerequisite packages which let apt use packages over HTTPS:

sudo apt install apt-transport-https ca-certificates curl software-properties-common

# 3.) Then add the GPG key for the official Docker repository to your system:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# 4.) Add the Docker repository to APT sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null


# Update your existing list of packages again for the addition to be recognized:
sudo apt update

# 5.) Make sure you are about to install from the Docker repo instead of the default Ubuntu repo:


# 6.) You’ll see output like this, although the version number for Docker may be different:

apt-cache policy docker-ce

# 7.) Finally, install Docker:
sudo apt install docker-ce

sleep 15

# 8.) Docker should now be installed, the daemon started, and the process enabled to start on boot. Check that it’s running:
sudo systemctl status docker
