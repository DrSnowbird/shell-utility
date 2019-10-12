#!/bin/bash -x

########################################################################################
#### This will setup both BASIC and SSL authenticatio for user/CLIENT app to access ####
########################################################################################

#### ---- Registry User login and password: ---- ####
REGISTRY_USER=${REGISTRY_USER:-docker_user}
REGISTRY_PSWD=${REGISTRY_PSWD:-docker_password}

## ref: https://ahmermansoor.blogspot.com/2019/03/configure-private-docker-registry-centos-7.html

DOCKER_HOST_FQDN=`hostname -f`
DOCKER_HOST_IP=`hostname -I | awk '{print $1}'`

#### ----  1.) Configure Basic HTTP Authentication for Private Docker Registry:
#We create a directory and then create a passwd file therein. we will mount this directory on registry container to implement basic HTTP authentication for our Private Docker Registry.
function basicAuthentication() {
    sudo mkdir -p ${DOCKER_REGISTRY_DIR}/auth
    sudo docker run \
        --entrypoint htpasswd \
        registry -Bbn ${REGISTRY_USER} ${REGISTRY_PSWD} > ${DOCKER_REGISTRY_DIR}/auth/htpasswd
}
basicAuthentication

#### ----  2.) Generate SSL certificate for Registry to use:
DOCKER_REGISTRY_DIR=${DOCKER_REGISTRY_DIR}
DOCKER_REGISTRY_CERTS_DIR=${DOCKER_REGISTRY_DIR}/certs

SSL_STATE=${SSL_STATE:-State}
SSL_COUNTRY=${SSL_COUNTRY:-US}
SSL_LOCALITY=${SSL_LOCALITY:-City}
SSL_ORG=${SSL_ORG:-Org}

ls -al $(basename ${DOCKER_REGISTRY_CERTS_DIR})
sudo mkdir -p ${DOCKER_REGISTRY_CERTS_DIR}
sudo openssl req  \
   -newkey rsa:2048 \
   -nodes -sha256 \
   -x509 -days 3650 \
   -keyout ${DOCKER_REGISTRY_CERTS_DIR}/docker_registry.key \
   -out ${DOCKER_REGISTRY_CERTS_DIR}/docker_registry.crt \
   -subj "/C=${SSL_COUNTRY}/ST=${SSL_STATE}/L=${SSL_LOCALITY}/O=${SSL_ORG}/CN=${DOCKER_HOST_FQDN}"

#### ----  3.) Create a Directory to persist Private Docker Registry Data:
# Create a directory on Docker host. 
# We will mount this directory in registry container and it will hold all data pertains to our Private Docker Registry.
#
# By detaching this directory from registry container, we can easily reuse it with other containers derived from registry image. 
# Therefore, if we remove our container, it won’t destroy the data within our Private Docker Registry.
sudo mkdir ${DOCKER_REGISTRY_DIR}/registry

#### ----  4.) Create a Private Docker Registry Container on CentOS 7:
# Pull registry image from Docker Hub.
sudo docker pull registry

# Create a container for Private SSL-based Docker Registry.
sudo docker run -d \
    --name docker-registry \
    --restart=always \
    -p 5000:5000 \
    -v ${DOCKER_REGISTRY_DIR}/registry:/var/lib/registry \
    -v ${DOCKER_REGISTRY_DIR}/auth:/auth \
    -e REGISTRY_AUTH=htpasswd \
    -e REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm \
    -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
    -v ${DOCKER_REGISTRY_DIR}/certs:/certs \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/docker-registry.crt \
    -e REGISTRY_HTTP_TLS_KEY=/certs/docker-registry.key \
    registry

sudo cp ${DOCKER_REGISTRY_CERTS_DIR}/docker_registry.crt /etc/docker/certs.d

# Ok our server side now uses our certs. Great! but we are not done yet.
# In order for clients to be able to connect the registry, we need their workstations to trust our CA. Otherwise, it won't connect. If your client machine already trust your CA certificate, you're done. Else, you need to copy your CA certificate over the machine. You can copy it to /etc/docker/certs.d and docker will trust it automatically, or for the OS to trust it you need to (On Ubuntu system, it may vary on other OS):
# Make sure to restart the docker service on the client after you do that.
## ---- For CentOS 7/8: ----
# copy your certificates inside
#   /etc/pki/ca-trust/source/anchors/
# then run the following command
#   sudo update-ca-trust
OS_TYPE=`cat /etc/os-release |grep '^NAME='|cut -d'"' -f2`
if [[ "$OS_TYPE" =~ "^CentOS" ]]; then
    # CentOS
    echo "---- OS Type: $OS_TYPE"
    # copy your certificates inside
    sudo cp ${DOCKER_REGISTRY_CERTS_DIR}/docker_registry.crt /etc/pki/ca-trust/source/anchors/
    # then run the following command
    sudo update-ca-trust
else
    if [[ "$OS_TYPE" =~ "^Ubuntu" ]]; then
        # Ubuntu
        echo "---- OS Type: $OS_TYPE"
        ## ---- For Ubuntu OS: -----
        # Copy it to /usr/local/share/ca-certificates/
        sudo cp ${DOCKER_REGISTRY_CERTS_DIR}/docker_registry.crt /usr/local/share/ca-certificates/
        sudo update-ca-certificates
    else
        echo "**** Unsupported OS Type: $OS_TYPE"
    fi
fi

#### ---- 5.) Add IP Address of Private Docker Registry to Local DNS resolver of Docker host
sudo cp /etc/hosts /etc/host.SAVE.`date +%F`
cat << EOF >> sudo tee -a /etc/hosts
${DOCKER_HOST_IP} docker-registry.${DOCKER_HOST_FQDN} docker-registry
EOF

#### ---- 6.) Pull an image from Docker Hub. We will later push this image to our Private Docker Registry.

sudo docker pull busybox

# Create another tag for busybox image, so we can push it into our Private Docker Registry.

sudo docker tag busybox:latest docker-registry.${DOCKER_HOST_FQDN}:5000/busybox

# Login to docker-registry.example.com using docker command.
sudo docker login docker-registry.${DOCKER_HOST_FQDN}:5000

# Push busybox image to Private Docker Registry.
sudo docker push docker-registry.${DOCKER_HOST_FQDN}:5000/busybox

# List locally available images of busybox
sudo docker images | grep busybox
