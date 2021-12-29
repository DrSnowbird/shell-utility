#!/bin/bash -x

VERSION=7.3.3
wget https://services.gradle.org/distributions/gradle-${VERSION}-bin.zip -P /tmp
sudo unzip -d /opt/gradle /tmp/gradle-${VERSION}-bin.zip

sudo ln -s /opt/gradle/gradle-${VERSION} /opt/gradle/latest

mkdir -p ~/bashrc-backup
cp --backup=numbered ~/.bashrc ~/bashrc-backup/

cat <<EOF>> ~/.bashrc
##### ---- gradle ---- ####
export GRADLE_HOME=/opt/gradle/latest
export PATH=\${GRADLE_HOME}/bin:\${PATH}

EOF
