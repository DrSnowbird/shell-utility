# First -> Install Python3 (on CentOS 7/8)
Two ways (at least) to setup Python3 on CentOS 7/8:
* Usin RPM package
# Two scripts to setup and run Virtualenvwrapper
* create-venv.sh: Create a new virtualenv environment, then you just "workon <new_venv>"
```
./create-venv.sh new_venv
workon new_venv
```
* setup_venv_bash_profile.sh: to add default virutalenvwrapper setup whenever you login
Setup bash profile, ~/.bashrc, to have proper variables for virtualenvwrapper to run.

# How to Install Virtualenvwrapper
```
# 1.) 1st step is to install pip for Python3
sudo apt-get install python3-pip

# 2.) Now you want to create a virtual environment for the project that you want to work on.
sudo pip3 install virtualenvwrapper
pip3 -V
```

# Way-1 (Most preferred approach)
## STEP-1) Setup virtualenvwrapper in $HOME/.bashrc profile
Add the following code to the end of ~/.bashrc
Or, run the script, tools/python-virtual/setup_venv_bash_profile.sh, 
to auto-setup the environment

```
#########################################################################
#### ---- Customization for multiple virtual python environment ---- ####
####      (most recommended approach and simple to switch venv)      ####
#########################################################################
function setup_virtualenvwrapper_in_bashrc() {
cat << EOF >> ~/.bashrc
#########################################################################
#### ---- Customization for multiple virtual python environment ---- ####
#########################################################################

# export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export VIRTUALENVWRAPPER_PYTHON=`which python3`
#source /usr/local/bin/virtualenvwrapper.sh
source `which virtualenvwrapper.sh`
#source /home/${USER}/.local/bin/virtualenvwrapper.sh
export WORKON_HOME=${BASE_DISK_MOUNT}/Envs
if [ ! -d $WORKON_HOME ]; then
    mkdir -p $WORKON_HOME
fi
EOF
}
if [ "`cat $HOME/.bashrc | grep -i virtual`" = "" ]; then
    #if [ "$WORKON_HOME" != "" ]; then
    setup_virtualenvwrapper_in_bashrc
fi
```
# STEP-2) To create & activate your default venv environment, say, to create a new venv, "my-venv":
```
mkvirtualenv my-venv
workon my-venv
```

# Way-2 (less preferred approach)
This assumes you already install venv, virtualenv, virtualenvwrapper
```
PYTHON_VERSION=36

# The new venv repo directory - store all isolated installed packages
VENV_DIR=venv36

virtualenv -p `which python${PYTHON_VERSION}` ${VENV_DIR}
```

# Exit venv environments:
```
exit
```

# Reference
https://virtualenvwrapper.readthedocs.io/en/latest/install.html#shell-startup-file
* [(install!) Python3 with VIRTUALENVWRAPPER](https://medium.com/@gitudaniel/installing-virtualenvwrapper-for-python3-ad3dfea7c717)
* [(use guide!) virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/)
* [virtualenv vs venv](https://stackoverflow.com/questions/41573587/what-is-the-difference-between-venv-pyvenv-pyenv-virtualenv-virtualenvwrappe)
* [Install latest Python 3.7](http://ubuntuhandbook.org/index.php/2019/02/install-python-3-7-ubuntu-18-04/)


