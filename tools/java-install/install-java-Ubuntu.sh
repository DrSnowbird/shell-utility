#!/bin/bash -x

INSTALL_DIR=/opt

JAVA_MAJOR_VERSION=${JAVA_MAJOR_VERSION:-8}
JAVA_UPDATE_VERSION=${JAVA_UPDATE_VERSION:-202}
JAVA_BUILD_NUMBER=${JAVA_BUILD_NUMBER:-08}
JAVA_DOWNLOAD_TOKEN=${JAVA_DOWNLOAD_TOKEN:-1961070e4c9b4e26a04e7f5a083f551e}

#### ---------------------------------------------------------------
#### ---- Don't change below unless you know what you are doing ----
#### ---------------------------------------------------------------
UPDATE_VERSION=${JAVA_MAJOR_VERSION}u${JAVA_UPDATE_VERSION}
BUILD_VERSION=b${JAVA_BUILD_NUMBER}

JAVA_HOME_ACTUAL=${INSTALL_DIR}/jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION}
JAVA_HOME=${INSTALL_DIR}/java

PATH=$PATH:${JAVA_HOME}/bin

cd ~
mkdir ~/tmp

curl -sL --retry 3 --insecure \
  --header "Cookie: oraclelicense=accept-securebackup-cookie;" \
  "http://download.oracle.com/otn-pub/java/jdk/${UPDATE_VERSION}-${BUILD_VERSION}/${JAVA_DOWNLOAD_TOKEN}/jdk-${UPDATE_VERSION}-linux-x64.tar.gz" -o jdk-${UPDATE_VERSION}-linux-x64.tar.gz

tar xvzf jdk-${UPDATE_VERSION}-linux-x64.tar.gz
sudo cp -r ./jdk1.${JAVA_MAJOR_VERSION}.0_${JAVA_UPDATE_VERSION} ${INSTALL_DIR}/
ls -al ${JAVA_HOME_ACTUAL} 
sudo ln -s ${JAVA_HOME_ACTUAL} ${JAVA_HOME} 

export JAVA_HOME=${INSTALL_DIR}/java
export PATH=$PATH:${JAVA_HOME}/bin
echo "export JAVA_HOME=${INSTALL_DIR}/java" >> ~/.bash_aliases
echo "export PATH=${PATH}:${JAVA_HOME}/bin" >> ~/.bash_aliases
source ~/.bash_aliases
java -version
