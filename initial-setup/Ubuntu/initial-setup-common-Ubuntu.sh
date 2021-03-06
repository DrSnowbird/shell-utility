#!/bin/bash -x

BASE_DISK_MOUNT=/mnt/seagate-3tb/

GIT_DIR=${BASE_DISK_MOUNT}/git-public

#mkdir -p ${GIT_DIR}

if [ ! -d ${GIT_DIR} ]; then
    echo "${GIT_DIR} not found! Cant' continue! Abort! "
    exit 1
fi

#### ---- Disable Sudo pasword requirement ---- ####
function disable_sudo_password() {
    # sudo viuser1sudo
    if [ ! "`sudo cat /etc/sudoers | grep ${USER}`" = "" ]; then
        echo "${USER}     ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
    fi
}
#disable_sudo_password

#### ---- Install common packages ---- ####
function install_common_packages() {
    for p in `cat ./packages.txt | grep -v "#" `; do
        if [ "$p" != "" ]; then
            sudo apt-get install -y $p
        fi
    done
}
#install_common_packages

#### ---- Install Google-Chrome ---- ####
function install_google_chrome() {
    cd ~
    sudo apt install -y gdebi-core wget
    wget -c -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    #sudo gdebi google-chrome-stable_current_amd64.deb
    cat /etc/apt/sources.list.d/google-chrome.list
    which google-chrome
}
if [ "`which google-chrome`" = "" ]; then
    install_google_chrome
fi

#### ---- Install git ---- ####
function install_git() {
    sudo apt install -y git meld
    USER_EMAIL=${USER}@openkbs.org
    USER_NAME=DrSnowbird
    git config --global user.email "${USER_EMAIL}"
    git config --global user.name "${USER_NAME}"
    if [ ! -d ${GIT_DIR}/shell-utility ]; then
        cd ${GIT_DIR}
        git clone git@github.com:DrSnowbird/shell-utility.git
    fi
}
if [ "`which git`" = "" ]; then
    install_git
fi

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

#### ---- Setup Aliases---- ####
function setup_aliases() {
    alias_setup_already="`cat ~/.bashrc | grep git-alias.sh`"
    if [ "$alias_setup_already" != "" ]; then
        cat << EOF >> ~/.bashrc
        
#### ---- Customized aliases ----
####

. ~/bin/git-alias.sh
. ~/bin/docker-alias.sh
. ~/bin/my-alias.sh

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=\${JAVA_HOME}:\${PATH}

EOF
    else
	    echo "..... setup_aliases(): already being set up!"
    fi

    if [ ! -s ~/bin/git-alias.sh ]; then
        cd ${GIT_DIR}/shell-utility/initial-setup/alias
        mkdir -p ~/bin
        cp git-alias.sh ~/bin
        cp docker-alias.sh ~/bin
        cd
        chmod +x ~/bin/*.sh
        source ~/.bashrc
        env
    else
        echo "*** ERROR: can't find ~/bin/git-alias.sh! Abort!"
    fi
    alias
}
setup_aliases

#### ---- Install Docker ---- ####
function install_docker() {
    cd ${GIT_DIR}/shell-utility/docker/installation
    ./docker-ce-install-Ubuntu.sh
}
install_docker

#### ---- Install SSH daemon ---- ####
function ssh_daemon() {
    sudo apt-get install -y openssh-server
    sudo service sshd status
    cat /etc/ssh/sshd_config
    sudo systemctl enable ssh
}
if [ "`which sshd`" = "" ]; then
    ssh_daemon
fi

#### ---- SSH keys setup ---- ####
function ssh_setup() {
    cd ~
    ssh-keygen
    cd ~/.ssh
    cat id_rsa.pub >> ./authorized_keys
    chmod 0644 authorized_keys 
}
if [ ! -s ~/.ssh/id_rsa ]; then
    ssh_setup
fi

#### ---- OpenJDK setup ---- ####
function java_install() {
    if [ -d ${GIT_DIR}/shell-utility/tools/java-install ]; then
        cd ${GIT_DIR}/shell-utility/tools/java-install
        ./install-openjdk8-Ubuntu.sh
        # latest JDK 11 as default from Ubuntu 20
        # ./install-java-Ubuntu-OpenJDK.sh
    fi
    java -
}
if [ "`which java`" = "" ]; then
    java_install
fi

#### ---- Docker setup ---- ####
function docker_install() {
    if [ -d ${GIT_DIR}/shell-utility/docker/installation ]; then
        cd ${GIT_DIR}/shell-utility/docker/installation
        ./docker-ce-install-Ubuntu.sh
    fi
}
if [ "`which docker`" = "" ]; then
    docker_install
fi

#### ---- Python3' pip3 setup ---- ####
function pip3_install() {
    sudo apt update -y
    sudo apt install -y python3-pip
    # The command above will also install all the dependencies required for building Python modules.
    # When the installation is complete, verify the installation by checking the pip version:
    pip3 --version
    sudo pip3 --no-cache-dir install --upgrade pip
    if [ -s ./requirements.txt ]; then
        #sudo pip3 --no-cache-dir install --ignore-installed -U -r ./requirements.txt
        sudo `which pip3` --no-cache-dir install -U -r ./requirements.txt
    fi
    pip3 --version
    sudo pip3 install virtualenv
    sudo pip3 install virtualenvwrapper
}
if [ "`which pip3`" = "" ]; then
    pip3_install
fi

#### ---- Desktop setup ---- ####
function setupDesktop() {
    # ref: https://askubuntu.com/questions/89417/how-to-span-single-wallpaper-over-dual-monitors
    # ref: https://ubuntuforums.org/showthread.php?t=2331219
    # -- To span desktop background images across two monitors
    gsettings set org.gnome.desktop.background picture-options spanned
    
    # -- To display actual FULL File Path (easier to copy the Path) instead visual 'bread crums as path' (not easy to copy)
    gsettings set org.gnome.nautilus.preferences always-use-location-entry true
    
    ## How to "Tweak" two monitor for multiple Workspace
    # You can install "gnome-tweak-tool" via "sudo apt install gnome-tweak-tool".
    sudo apt install -y gnome-tweaks 
    # Then go to Workspaces > Display Handling > And choose Workspaces span displays
}
setupDesktop

function customize_local_bin_to_use_shell_utility() {
    cp ${GIT_DIR}/shell-utility/docker/bin/* $HOME/bin/
    cp ${GIT_DIR}/shell-utility/common/bin/* $HOME/bin/
}
customize_local_bin_to_use_shell_utility
