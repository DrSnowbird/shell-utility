#!/bin/bash -x

############# -------- Testing using busybox ------- ###############
echo "-------------------------------------------------------------------------"
echo "---- Usage: $(basename $0) [ <container_image> [<remote_registry_host>] ] "
echo "---- <container_image>: default=busybox> "
echo "---- <remote_registry_host>: remote SSL-based Docker Registry Host's FQDN"
echo "-------------------------------------------------------------------------"

TEST_CONTAINER=${1:-busybox}
DOCKER_HOST_FQDN=${2:-`hostname -f`}

function test_push_pull_Registry_SSL() {

    #### ---- Pull an image from Docker Hub. We will later push this image to our Private Docker Registry.
    sudo docker pull ${TEST_CONTAINER}

    # Create another tag for ${TEST_CONTAINER} image, so we can push it into our Private Docker Registry.

    sudo docker tag ${TEST_CONTAINER}:latest ${DOCKER_HOST_FQDN}:5000/${TEST_CONTAINER}

    # Login to docker-registry.example.com using docker command.
    #sudo docker login ${DOCKER_HOST_FQDN}:5000
    #sudo chown -R $USER:$USER ~/.docker

    # Push ${TEST_CONTAINER} image to Private Docker Registry.
    sudo docker push ${DOCKER_HOST_FQDN}:5000/${TEST_CONTAINER}
    sudo docker pull ${DOCKER_HOST_FQDN}:5000/${TEST_CONTAINER}

    # List locally available images of ${TEST_CONTAINER}
    sudo docker images | grep ${TEST_CONTAINER}
}

test_push_pull_Registry_SSL
