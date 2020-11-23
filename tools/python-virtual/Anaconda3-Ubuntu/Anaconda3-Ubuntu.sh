#!/bin/bash -x

#### ---- Anaconda Navigator ----
sudo apt -y install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6

mkdir ~/tmp
cd ~/tmp

#cd /mnt/seagate-3tb/tools

CONDA3_URL=https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
#wget --no-check-certificate https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
wget --no-check-certificate -c ${CONDA3_URL}

bash $(basename ${CONDA3_URL})


