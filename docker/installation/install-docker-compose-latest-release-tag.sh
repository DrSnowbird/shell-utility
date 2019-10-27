#!/bin/bash

#### ---- Install: docker-compose ----
org=${1:-docker}
repo=${2:-compose}

#sudo yum install jq net-tools -y

OS="`awk -F= '/^NAME/{print $2}' /etc/os-release`"
#"Ubuntu"`
#"CentOS Linux"

if [ $OS == \"Ubuntu\" ]; then
    echo "sudo apt install -y jq"
else
    echo "not Ubuntu"
fi
if [[ "$OS" == \"CentOS Linux\" ]]; then
    echo "sudo yum install -y jq"
else
    echo "not CentOS"
fi

release=`curl https://api.github.com/repos/$org/$repo/releases/latest -s | jq .name -r`
echo "Latest ${org}/$repo release= ${release}"

sudo curl -L https://github.com/${org}/${repo}/releases/download/${release}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

docker-compose -v
