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
release=`curl https://api.github.com/repos/$org/$repo/releases/latest -s | jq .name -r`
echo "Latest ${org}/$repo release= ${release}"
sudo curl -L https://github.com/${org}/${repo}/releases/download/${release}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

docker-compose -v
