#!/bin/bash -x

########################################
#### ------- OpenJDK Installation ------
########################################


sudo apt-get update -y
sudo apt install -y default-jdk
#sudo apt-get install -y --no-install-recommends openjdk-8-jdk
sudo rm -rf /var/lib/apt/lists/*

echo ">> JAVA_HOME= $(readlink -f $JAVA_HOME)"

# update-alternatives so that future installs of other OpenJDK versions don't change /usr/bin/java
sudo update-alternatives --get-selections | awk -v home="$(readlink -f $JAVA_HOME)" 'index($3, home) == 1 { $2 = "manual"; print | "update-alternatives --set-selections" }'

# ... and verify that it actually worked for one of the alternatives we care about
sudo update-alternatives --query java | grep -q 'Status: manual'

# If you're reading this and have any feedback on how this image could be
# improved, please open an issue or a pull request so we can discuss it!
#
#   https://github.com/docker-library/openjdk/issues

export JAVA_HOME=/usr/lib/jvm/default-java
export PATH=$JAVA_HOME/bin:$PATH

echo "export JAVA_HOME=${JAVA_HOME}" >> ~/.bashrc
echo "export PATH=${PATH}:\${JAVA_HOME}/bin" >> ~/.bashrc

source ~/.bashrc
java -version
