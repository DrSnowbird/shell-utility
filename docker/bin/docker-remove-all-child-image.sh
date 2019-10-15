#!/bin/bash -x

if [ $# -lt 1 ]; then
    echo "Usage: "
    echo "  ${0} <image_id>"
fi

IMAGE_ID=${1}
docker rmi -f $(docker inspect --format='{{.Id}} {{.Parent}}' $(docker images --filter since=${IMAGE_ID} -q)|cut -d':' -f2|cut -c-12)

docker images -q
