#!/bin/bash -x

BASE_DISK_MOUNT=/mnt/seagate-3tb/

ROOT_DIR=~/git-public

#mkdir -p ${ROOT_DIR}

if [ ! -d ${ROOT_DIR} ]; then
    echo "${ROOT_DIR} not found! Cant' continue! Abort! "
    exit 1
fi

#### ---- Disable Sudo pasword requirement ---- ####
function disable_sudo_password() {
    # sudo viuser1sudo
    if [ ! "`sudo cat /etc/sudoers | grep ${USER}`" = "" ]; then
        echo "${USER}     ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers
    fi
}
disable_sudo_password

#### ---- Install common packages ---- ####
function install_common_packages() {
    for p in `cat ./packages.txt|grep -v "#"`; do
        sudo apt-get install -y $p
    done
}
install_common_packages

#### ---- Install Google-Chrome ---- ####
function install_google_chrome() {
    cd ~
    wget -c -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    cat /etc/apt/sources.list.d/google-chrome.list
}
if [ "`which google-chrome`" = "" ]; then
    install_google_chrome
fi

#### ---- Install git ---- ####
function install_git() {
    sudo apt install -y git meld
    USER_EMAIL=${USER}@openkbs.org
    USER_NAME=openkbs
    git config --global user.email "${USER_EMAIL}"
    git config --global user.name "${USER_NAME}"
    if [ ! -d ${ROOT_DIR}/shell-utility ];
        cd ${ROOT_DIR}
        git clone git@github.com:DrSnowbird/shell-utility.git
    fi
}
if [ "`which git`" = "" ]; then
    install_git
fi

#### ---- Setup Python Virtualenvwrapper in $HOME/.bashrc file  ---- ####

function setup_virtualenvwrapper_in_bashrc() {
cat << EOF >> ~/.bashrc
    #########################################################################
    #### ---- Customization for multiple virtual python environment ---- ####
    #########################################################################

    export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
    source /usr/local/bin/virtualenvwrapper.sh
    #source /home/${USER}/.local/bin/virtualenvwrapper.sh
    #export WORKON_HOME=${BASE_DISK_MOUNT}/Envs
    if [ ! -d $WORKON_HOME ]; then
        mkdir -p $WORKON_HOME
    fi
EOF
}
if [ "$WORKON_HOME" != "" ]; then
    setup_virtualenvwrapper_in_bashrc
fi

#### ---- Setup Aliases---- ####
function setup_aliases() {
    alias_setup_already="`cat ~/.bash_aliases | grep git-alias.sh`"
    if [ "$alias_setup_already" != "" ]; then
        cat << EOF >> ~/.bash_aliases
#!/bin/bash -x
. ~/bin/git-alias.sh
. ~/bin/docker-alias.sh

. ~/bin/my-alias.sh

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=\${JAVA_HOME}:\${PATH}

EOF
    fi

    if [ ! -s ~/bin/git-alias.sh ]; then
	    cd ${ROOT_DIR}/shell-utility/initial_setup
	    mkdir -p ~/bin
	    cp ./setup/git-alias.sh ~/bin
	    cp ./setup/docker-alias.sh ~/bin
	    chmod +x ~/bin/*.sh

	    source ~/.bash_aliases 
	fi
}
setup_aliases

#### ---- Install Docker ---- ####
function install_docker() {
    cd ${ROOT_DIR}/shell-utility/docker/installation
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
function java8_install() {
    if [ -d ${ROOT_DIR}/shell-utility/tools/java-install ]; then
        cd ${ROOT_DIR}/shell-utility/tools/java-install
        ./install-java-Ubuntu.sh
        ./install-java-Ubuntu-OpenJDK.sh
    fi
}
if [ "`which java`" = "" ]; then
    java8_install
fi

#### ---- Docker setup ---- ####
function docker_install() {
    if [ -d ${ROOT_DIR}/shell-utility/docker/installation ]; then
        cd ${ROOT_DIR}/shell-utility/docker/installation
        ./docker-ce-install-Ubuntu.sh
    fi
}
if [ "`which docker`" = "" ]; then
    docker_install
fi

#### ---- Python3' pip3 setup ---- ####
function pip3_setup() {
    sudo pip3 --no-cache-dir install --upgrade pip 
    #sudo pip3 --no-cache-dir install --ignore-installed -U -r ./requirements.txt
    sudo `which pip3` --no-cache-dir install -U -r ./requirements.txt
}
#pip3_setup

#### ---- Desktop setup ---- ####
function setupDesktop() {
    # ref: https://askubuntu.com/questions/89417/how-to-span-single-wallpaper-over-dual-monitors
    # ref: https://ubuntuforums.org/showthread.php?t=2331219
    # -- To span desktop background images across two monitors
    gsettings set org.gnome.desktop.background picture-options spanned
    #gsettings set org.gnome.nautilus.preferences always-use-location-entry true
}
setupDesktop
