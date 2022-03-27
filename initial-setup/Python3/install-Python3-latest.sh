#!/bin/bash -x

PYTHON3_TGZ_URL=$(curl -k -s https://www.python.org/downloads/source/ | grep 'tgz'|head -1|cut -d'"' -f2)

PYTHON3_TGZ=$(basename ${PYTHON3_TGZ_URL})

PYTHON3_VERSION_FULL=${PYTHON3_TGZ%%.tgz}
PYTHON3_VERSION=${PYTHON3_VERSION_FULL%.*}
PYTHON3_VERSION=$(echo ${PYTHON3_VERSION}|cut -d'-' -f2)
PYTHON3=python${PYTHON3_VERSION}

function install_python3_alt() {
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
    sudo rm -f /usr/bin/python3
    sudo ln -s /usr/local/bin/${PYTHON3} /usr/bin/python3
}
install_python3_alt

#which python3.10
which ${PYTHON3}
${PYTHON3} -V

python3 -V

python3 -m pip install --upgrade pip

