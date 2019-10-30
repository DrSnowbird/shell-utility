#!/bin/bash -x

javaVer=${1:-"11"}

sudo yum update -y

if [ "$javaVer" == "8" ]; then
    sudo yum install -y java-1.8.0-openjdk
    sudo update-alternatives --config java
    echo "export JAVA_HOME=/usr/lib/jvm/java-${javaVer}-openjdk" >> ~/.bashrc
    
elif [ "$javaVer" == "11" ]; then
    sudo yum install -y java-11-openjdk-devel
    echo "export JAVA_HOME=/usr/lib/jvm/java-${javaVer}-openjdk" >> ~/.bashrc
else
    echo "*** ERROR: not supported JAVA version $javaVer "
fi


