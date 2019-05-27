#!/bin/bash -x

echo "Y" | sudo add-apt-repository ppa:webupd8team/java

# When you add the repository, you'll see a message like this:
# 
# output
#  Oracle Java (JDK) Installer (automatically downloads and installs Oracle JDK8). There are no actual Jav
# a files in this PPA.
# 
# Important -> Why Oracle Java 7 And 6 Installers No Longer Work: http://www.webupd8.org/2017/06/why-oracl
# e-java-7-and-6-installers-no.html
# 
# Update: Oracle Java 9 has reached end of life: http://www.oracle.com/technetwork/java/javase/downloads/j
# dk9-downloads-3848520.html
# 
# The PPA supports Ubuntu 18.04, 17.10, 16.04, 14.04 and 12.04.
# 
# More info (and Ubuntu installation instructions):
# - for Oracle Java 8: http://www.webupd8.org/2012/09/install-oracle-java-8-in-ubuntu-via-ppa.html
# 
# Debian installation instructions:
# - Oracle Java 8: http://www.webupd8.org/2014/03/how-to-install-oracle-java-8-in-debian.html
# 
# For Oracle Java 10, see a different PPA: https://www.linuxuprising.com/2018/04/install-oracle-java-10-in-ubuntu-or.html
# 
# More info: https://launchpad.net/~webupd8team/+archive/ubuntu/java
# Press [ENTER] to continue or Ctrl-c to cancel adding it.
# Press ENTER to continue. Then update your package list:
# 
sudo apt update -y

# Once the package list updates, install Java 8:

sudo apt install -y oracle-java8-installer

export JAVA_HOME=/usr/lib/jvm/java-8-oracle/
export PATH=$PATH:${JAVA_HOME}/bin

echo "export JAVA_HOME=${JAVA_HOME}" >> ~/.bash_aliases
echo "export PATH=${PATH}" >> ~/.bash_aliases

source ~/.bash_aliases
java -version

sudo update-alternatives --config java
