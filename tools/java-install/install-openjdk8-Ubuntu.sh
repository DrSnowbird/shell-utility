#!/bin/bash -x

sudo apt update -y

# Once the package list updates, install Java 8:

sudo apt install -y openjdk-8-jdk

export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export PATH=$PATH:${JAVA_HOME}/bin

echo "export JAVA_HOME=${JAVA_HOME}" >> ~/.bash_aliases
echo "export PATH=${PATH}" >> ~/.bash_aliases

source ~/.bash_aliases
java -version

sudo update-alternatives --config java
