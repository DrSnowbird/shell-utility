#!/bin/bash -x

# 1. Create volume
docker volume create portainer_data

# 2. run Portainer
docker run -d -p 8000:8000 -p 9443:9443 --name portainer-v2 \
    --restart=always \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    portainer/portainer-ce:2.9.3
