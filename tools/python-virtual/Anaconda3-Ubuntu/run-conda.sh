#!/bin/bash -x

#####################################################
# >>> conda initialize >>>
#####################################################
CONDA3_HOME=~/anaconda3
export PATH=$PATH:${CONDA3_HOME}/bin

if [ ! -s $CONDA3_HOME ]; then
    echo "Anaconda3 HOME is not found! Abort!"
    exit 1
fi

function conda3_initialze() {
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/mnt/seagate-3tb/tools/Anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
__conda_setup="$($CONDA3_HOME/bin/conda 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA3_HOME/etc/profile.d/conda.sh" ]; then
        . "$CONDA3_HOME/etc/profile.d/conda.sh"
    else
        export PATH="$PATH:$CONDA3_HOME/bin"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
}
#conda3_initialze

if [ $# -lt 1 ]; then
    echo "*** ERROR: provide Conda env name! Abort!"
    exit 1
fi
envName=$1
shift
conda create -n "$1" $@
