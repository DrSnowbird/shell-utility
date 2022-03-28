#!/bin/bash -x

function usage() {
    echo -e "---- Usage: $0 [<ENABLE_PYTHON_LATEST: 0, 1>]"
}
usage

ENABLE_PYTHON_LATEST=${1:-1}

PYTHON3_TGZ_URL=$(curl -k -s https://www.python.org/downloads/source/ | grep 'tgz'|head -1|cut -d'"' -f2)

PYTHON3_TGZ=$(basename ${PYTHON3_TGZ_URL})

PYTHON3_VERSION_FULL=${PYTHON3_TGZ%%.tgz}
PYTHON3_VERSION=${PYTHON3_VERSION_FULL%.*}
PYTHON3_VERSION=$(echo ${PYTHON3_VERSION}|cut -d'-' -f2)
PYTHON3=python${PYTHON3_VERSION}

function install_python3_alt() {
    sudo apt update -y
    sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev

    wget -q --no-check-certificate -c ${PYTHON3_TGZ_URL}

    #tar -xf Python-3.10.4.tgz
    tar -xf ${PYTHON3_TGZ}

    #cd Python-3.10.4
    cd ${PYTHON3_VERSION_FULL}

    ./configure --enable-optimizations
    make -j ${CPU:-4}
    sudo make altinstall

    #sudo rm -f /usr/bin/python3
    #sudo ln -s /usr/local/bin/python3.10 /usr/bin/python3
    if [ ${ENABLE_PYTHON_LATEST} -gt 0 ]; then
        sudo rm -f /usr/bin/python3
        sudo ln -s /usr/local/bin/${PYTHON3} /usr/bin/python3
        #which python3.10
        echo -e ">>> Test the latest Python3: "
        which ${PYTHON3}
        ${PYTHON3} -V
    else
        echo -e ">>> Not to enable the latest Python3, e.g., 3.10"
    fi
}
install_python3_alt


echo -e ">>> Final Test the latest Python3: "
python3 -V

python3 -m pip install --upgrade pip

