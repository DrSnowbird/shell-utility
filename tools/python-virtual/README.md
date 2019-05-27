# Install Virtualenvwrapper
```
# 1.) 1st step is to install pip for Python3
sudo apt-get install python3-pip

# 2.) Now you want to create a virtual environment for the project that you want to work on.
sudo pip3 install virtualenvwrapper
pip3 -V
```
# Setup virtualenvwrapper in $HOME/.bashrc profile
Add the following code to the end of ~/.bashrc
```
#########################################################################
#### ---- Customization for multiple virtual python environment ---- ####
#########################################################################
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
export WORKON_HOME=~/Envs
if [ ! -d $WORKON_HOME ]; then
    mkdir -p $WORKON_HOME
fi
```

# To create & activate your default venv environment, say, "venv-Weatherbot-Tutorial":
```
mkvirtualenv my-venv
workon my-venv
```

# Create virtualenvwrapper 
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


