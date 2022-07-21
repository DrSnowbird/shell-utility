#!/bin/bash -x

# 1. Create volume
docker volume create portainer_data

# 2. run Portainer
release="`curl -k -s https://github.com/portainer/portainer/releases/ | grep "/portainer/releases/tag" | head -1|cut -d'"' -f6|cut -d'/' -f6`"
docker run -d -p 8000:8000 -p 9443:9443 --name portainer-v2 \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:${release}

echo -e
echo -e ">>>>>> To access the new portainer:"
echo -e "   https://localhost:9443/"
echo -e
