#!/bin/bash -x

#### ---- developer: ----
#### author: DrSnowbird
#### date: 2021-08-16

set -e

#### ---- Usage: ----
function usage() {
    echo "-----------------------------------------------------------------------------" 
    echo "---- Usage: $(basename $0) <Python_Version: default=3> "
    echo ">>>> Default to use Python version 3 if you did not provide specific version!" 
    echo "-----------------------------------------------------------------------------" 
}

if [[ "$1" == @(-h|-H) ]]; then
    usage $@
    exit 0
fi

#### ---- Variables: ----
PYTHON_VERSION=${1:-3}

read -r -p ".... (CTRL-C to Abort CONDA Installation!) or press any key to continue immediately" -t 5 -n 1 -s
if [ $# -lt 1 ]; then
    usage $@
fi

#### ---- Anaconda Navigator ----
#sudo apt -y install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6

#### ---- Install: CONDA ----
CONDA_URL=https://repo.anaconda.com/archive/
latest_conda=`curl -s ${CONDA_URL} | grep "Linux-x86_64.sh" |  grep "Anaconda${PYTHON_VERSION}" | cut -d'"' -f2|sort|tail -1`
function install_conda() {
    if [[ "${PYTHON_VERSION}" == @(2|3) ]] ; then
        echo ">> Latest Anaconda version: ${latest_conda}"
        #curl -sS "https://repo.anaconda.com/archive/Anaconda${PYTHON_VERSION}-${LATEST_ANACONDA_VERSION}-Linux-x86_64.sh" -o ${latest_conda}
        curl -s ${CONDA_URL}${latest_conda} -o ${latest_conda}
        bash ./${latest_conda} -b
        rm ./${latest_conda}
    else
        echo "**** ERRROR: Bad version: ${PYTHON_MAJOR}: only 2 or 3 are supported!"
        exit 1
    fi
}

#### ---- Setup: CONDA ----
function setup_bashrc() {
    setup_before=`cat ~/.bashrc | grep -i CURL_CA_BUNDLE`
    if [ "${setup_before}" != "" ]; then
        echo "---- Anaconda CURL_CA_BUNDLE being setup before! Skip this setup!"
    else
        echo "## -- Anaconda Cerificate setup: --" >> ~/.bashrc
        echo "export CURL_CA_BUNDLE=/etc/pki/tls/certs/ca-bundle.crt" >> ~/.bashrc
        echo "export PATH=$HOME/anaconda${PYTHON_VERSION}/bin:$PATH"
    fi
    source "$HOME/.bashrc"
}

function test_conda() {
    conda create -n tf_test -y tensorflow-gpu numpy
}

function setup_condarc() {
#    CONDARC="ssl_verify: /etc/pki/tls/certs/ca-bundle.crt"
#    echo "${CONDARC}" > "$HOME/.condarc"
cat <<EOF> $HOME/.condarc
ssl_verify: /etc/pki/tls/certs/ca-bundle.crt
EOF
}

####################
#### ---- Main: ----
####################
install_conda
setup_bashrc
setup_condarc

source "$HOME/.bashrc"
#test_conda

echo "---- SUCCESS: Install: ${latest_conda}"
echo "`which conda`"

