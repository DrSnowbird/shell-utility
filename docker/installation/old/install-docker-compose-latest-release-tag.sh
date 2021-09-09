#!/bin/bash -x

#### ---- Install: docker-compose ----
org=${1:-docker}
repo=${2:-compose}

#sudo yum install jq net-tools -y
OS=`cat /etc/os-release | grep "^NAME" |cut -d'"' -f2 `
#"Ubuntu"
#"CentOS Linux"
echo "OS=$OS"
if [ "$OS" = "Ubuntu" ]; then
    sudo apt install -y jq
else
    echo "not Ubuntu"
fi
if [ "$OS" = "CentOS Linux" ]; then
    wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64
    sudo cp jq /usr/bin/
    sudo chmod +x /usr/bin/jq
    rm jq
else
    echo "not CentOS"
fi

docker-compose -v

DOCKER_COMPOSE_DIR=/usr/bin
DOCKER_COMPOSE_DIR_LOCAL=/usr/local/bin

release=`curl https://api.github.com/repos/$org/$repo/releases/latest -s | jq .name -r`
echo "...>> Latest ${org}/$repo release= ${release}"

sudo rm -f ${DOCKER_COMPOSE_DIR_LOCAL}/docker-compose ${DOCKER_COMPOSE_DIR}/docker-compose

#curl -L https://github.com/docker/compose/releases/download/1.25.0/docker-compose-Linux-x86_64 -o docker-compose
curl -L https://github.com/${org}/${repo}/releases/download/${release}/docker-compose-`uname -s`-`uname -m` -o ./docker-compose
chmod +x ./docker-compose

sudo cp ./docker-compose ${DOCKER_COMPOSE_DIR}/docker-compose
rm -f ./docker-compose

ls -al ${DOCKER_COMPOSE_DIR}/docker-compose

docker-compose -v

