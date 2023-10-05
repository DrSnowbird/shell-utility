#!/bin/bash

echo "--- Usage: "
echo "$(basename $0) <Anaconda3_HOME_PATH>"

###
#### You just cut-and-paste the following code into the end of ~/.bashrc file
####

export CONDA3_HOME=${HOME}/anaconda3
CONDA3_HOME=${1:-$CONDA3_HOME}
if [ "$CONDA3_HOME" == "" ] || [ ! -d $CONDA3_HOME ] ; then
    echo "echo "CONDA3_HOME is None or directory ${CONDA3_HOME} not existing!"
    echo "echo "Please provide 'CONDA HOME directory path' as argument! Abort ..."
    exit 1
fi

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
echo # To activate this environment, use
echo #
echo # $ conda activate myenv
echo #
echo # To deactivate an active environment, use
echo #
echo # $ conda deactivate
echo

setup_bashrc_v3

setup_condarc

exit 0

