#!/bin/bash -x

cat <<EOF >> ~/.bashrc

. ~/bin/git-alias.sh
. ~/bin/docker-alias.sh
. ~/bin/my-alias.sh
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64export 
PATH=\${JAVA_HOME}:\${PATH}

EOF
