#!/bin/bash -x

echo "--- Usage: "
echo "$(basename $0) <Anaconda3_HOME_PATH>"

###
#### You just cut-and-paste the following code into the end of ~/.bashrc file
####

CONDA3_HOME=${1:-/usr/local}
if [ ! -d

FIND_SETUP=`cat ~/.bashrc | grep "conda3_initialize"`
if [ "${FIND_SETUP}" = "" ]; then
cat >> ~/.bashrc <<EOF
function conda3_initialize() {
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="\$(${CONDA3_HOME}/bin/conda 'shell.bash' 'hook' 2> /dev/null)"
if [ \$? -eq 0 ]; then
    eval "\$__conda_setup"
else
    if [ -f "\${CONDA3_HOME}/etc/profile.d/conda.sh" ]; then
        . "\${CONDA3_HOME}/etc/profile.d/conda.sh"
    else
        export PATH="\${CONDA3_HOME}/bin:\$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
}
conda3_initialize
EOF
else
    echo "*** CONDA3 Setup script already in ~/.bashrc file!"
    echo "... do thing!"
fi
