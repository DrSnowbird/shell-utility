#!/bin/bash

#### ---- developer: ----
#### author: DrSnowbird
#### date: 2023-10-05

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

export CONDA3_HOME=${CONDA3_HOME}
export PATH=$PATH:${CONDA3_HOME}/bin

#### ---- Setup: CONDA ---- ####
function setup_bashrc_v3() {
    if [ "$CONDA3_HOME" == "" ] || [ ! -d $CONDA3_HOME ] ; then
        echo "echo "CONDA3_HOME is None or directory ${CONDA3_HOME} not existing!"
        echo "echo "Please provide 'CONDA HOME directory path' as argument! Abort ..."
        exit 1
    fi

    #FIND_SETUP=`cat ~/.bashrc | grep conda3_initialize`
    #if [ ! "${FIND_SETUP}" == "" ]; then
    setup_before=`cat ~/.bashrc | grep -i conda3_initialize`
    echo ">>> setup_before search=${setup_before}"
    if [ "${setup_before}" != "" ]; then
        echo "*** CONDA3 Setup script already in ~/.bashrc file!"
        echo "... do thing!"
        return
    else
        echo ">>> Insert CONDA3 setup into ~/.bashrc file ..."
    fi

    cat >>$HOME/.bashrc<<EOF

##########################
#### ---- Conda: ---- ####
##########################
export CONDA3_HOME=\${HOME}/anaconda3
export PATH=\$PATH:\${CONDA3_HOME}/bin

function conda3_initialize() {
# added by Anaconda3 5.3.1 installer
# >>> conda init >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="\$(CONDA_REPORT_ERRORS=false \${CONDA3_HOME}/bin/conda shell.bash hook 2> /dev/null)"
if [ \$? -eq 0 ]; then
    eval "\$__conda_setup"
else
    if [ -f "\${HOME}/anaconda3/etc/profile.d/conda.sh" ]; then
        . "\${HOME}/anaconda3/etc/profile.d/conda.sh"
        CONDA_CHANGEPS1=false conda activate base
    else
        export PATH="\${HOME}/anaconda3/bin:\$PATH"
    fi
fi
unset __conda_setup
# <<< conda init <<<
}
conda3_initialize

export SSL_NO_VERIFY=1

EOF
    tail -n 26  ~/.bashrc
}


#### ---- test create conda myenv: ---- ####
function test_conda() {
    conda create -n tf_test -y tensorflow-gpu numpy
}

#### ---- setup .condarc: ---- ####
function setup_condarc() {
#    CONDARC="ssl_verify: /etc/pki/tls/certs/ca-bundle.crt"
#    echo "${CONDARC}" > "$HOME/.condarc"
cat <<EOF> $HOME/.condarc
ssl_verify: 0
EOF
}

####################
#### ---- Main: ----
####################
install_conda
setup_bashrc_v3
setup_condarc

source "$HOME/.bashrc"
#test_conda

echo "---- SUCCESS: Install: ${latest_conda}"
echo "`which conda`"
echo
echo "---- Tips: to create and acticate ----"
echo "conda create --name myenv -c conda-forge python=3.9"
echo "conda activate myenv"
echo " ... then you are ready to use ..."
echo
echo To activate this environment, use
echo 
echo     conda activate myenv
echo 
echo To deactivate an active environment, use
echo 
echo     conda deactivate
echo
