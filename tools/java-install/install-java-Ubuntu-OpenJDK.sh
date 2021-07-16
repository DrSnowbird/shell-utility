#!/bin/bash

########################################
#### ------- OpenJDK Installation ------
########################################

## -- Change to version you want, e.g., 8, 11, etc.
export JAVA_VERSION=11

sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata

sudo apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
export LANG=en_US.utf8

sudo apt-get update -y

#sudo apt install -y default-jdk
#sudo apt-get install -y --no-install-recommends openjdk-8-jdk
sudo apt-get install -y openjdk-${JAVA_VERSION}-jdk 

sudo rm -rf /var/lib/apt/lists/*

export JAVA_HOME=/usr/lib/jvm/java-${JAVA_VERSION}-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

echo ">> JAVA_HOME= $(readlink -f /usr/bin/java)"

sudo update-alternatives --list java
#/usr/lib/jvm/java-11-openjdk-amd64/bin/java
#/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

java_cnt=`sudo update-alternatives --list java 2>/dev/null |grep -n java |wc -l`
if [ $java_cnt -gt 1 ]; then
    ## -- manually setup choice '1' : java-11 
    ## (if needed, enable this line below)
    echo "1" >> sudo update-alternatives --set-selections
else
    echo ">>>> ....There is only one alternative in link group java (providing /usr/bin/java): Nothing to configure."
fi

## -- To prevent future update /usr/bin/java link to other version: set value to 1 
##
prevent_future_update=0
if [ $prevent_future_update -gt 0 ]; then
    ## -- Use update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
    sudo update-alternatives --get-selections | awk -v home="$(readlink -f $JAVA_HOME)" 'index($3, home) == 1 { $2 = "manual"; print | "sudo update-alternatives --set-selections" }'

    ## -- Now, verify that it actually worked for one of the alternatives we care about
    sudo update-alternatives --query java | grep -q 'Status: manual'
fi

## -- Setup Shell profile:
echo "export JAVA_HOME=${JAVA_HOME}" >> ~/.bashrc
echo "export PATH=${PATH}:\${JAVA_HOME}/bin" >> ~/.bashrc

source ~/.bashrc
java -version

