#!/bin/bash -x

sudo apt update -y
apt list --upgradable
sudo apt upgrade -y
sudo apt install -y nodejs npm
nodejs --version
npm --version

