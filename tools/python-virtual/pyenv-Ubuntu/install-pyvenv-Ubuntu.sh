#!/bin/bash -x

#sudo apt-get install -y build-essential libssl-dev zlib1g-dev libbz2-dev \
#libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev \
#xz-utils tk-dev libffi-dev liblzma-dev python-openssl git
#
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

export PYENV_ROOT=$HOME/.pyenv
export PATH=$PATH:$PYENV_ROOT/bin
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

FIND_SETUP=`cat ~/.bashrc | grep "PYENV_ROOT"`
if [ "${FIND_SETUP}" = "" ]; then
    cat >> ~/.bashrc <<EOF
#### ----------------------- ####
#### ---- PyVenv setup: ---- ####
#### ----------------------- ####
export PYENV_ROOT=\$HOME/.pyenv
export PATH=\$PATH:\$PYENV_ROOT/bin
eval "\$(pyenv init --path)"
eval "\$(pyenv init -)"
eval "\$(pyenv virtualenv-init -)"
#pyenv virtualenv myenv
#pyenv activate myenv
EOF
fi

