#!/bin/bash -x

########################################################################################
#### This will setup both BASIC and SSL authenticatio for user/CLIENT app to access ####
########################################################################################

#### ---- Registry User login and password: ---- ####
REGISTRY_USER=${REGISTRY_USER:-docker_user}
REGISTRY_PSWD=${REGISTRY_PSWD:-dockdr_user}

## ref: https://ahmermansoor.blogspot.com/2019/03/configure-private-docker-registry-centos-7.html

DOCKER_HOST_FQDN=`hostname -f`
DOCKER_HOST_IP=`hostname -I | awk '{print $1}'`

#### ----  1.) Generate SSL certificate for Registry to use:
DOCKER_REGISTRY_DIR=${DOCKER_REGISTRY_DIR:-/opt/docker/containers/docker-registry}
DOCKER_REGISTRY_CERTS_DIR=${DOCKER_REGISTRY_DIR}/certs
REGISTRY_KEY=docker-registry.key
REGISTRY_CERT=docker-registry.crt

SSL_COUNTRY=${SSL_COUNTRY:-US}
SSL_STATE=${SSL_STATE:-MD}
SSL_LOCALITY=${SSL_LOCALITY:-Aberdeen}
SSL_ORG=${SSL_ORG:-Org}
SSL_CN=${SSL_CN:-${DOCKER_HOST_FQDN}}

ls -al $(dirname ${DOCKER_REGISTRY_CERTS_DIR})
sudo mkdir -p ${DOCKER_REGISTRY_CERTS_DIR}
sudo openssl req  \
   -newkey rsa:2048 \
   -nodes -sha256 \
   -x509 -days 3650 \
   -keyout ${DOCKER_REGISTRY_CERTS_DIR}/${REGISTRY_KEY} \
   -out ${DOCKER_REGISTRY_CERTS_DIR}/${REGISTRY_CERT} \
   -subj "/C=${SSL_COUNTRY}/ST=${SSL_STATE}/L=${SSL_LOCALITY}/O=${SSL_ORG}/CN=${SSL_CN}"

ls -al ${DOCKER_REGISTRY_CERTS_DIR}

#### ----  2.) Configure Basic HTTP Authentication for Private Docker Registry:
#We create a directory and then create a passwd file therein. we will mount this directory on registry container to implement basic HTTP authentication for our Private Docker Registry.
sudo mkdir -p ${DOCKER_REGISTRY_DIR}/auth
sudo docker run \
    --name tmp-registry \
    --entrypoint htpasswd \
    registry -Bbn ${REGISTRY_USER} ${REGISTRY_PSWD} | sudo tee ${DOCKER_REGISTRY_DIR}/auth/htpasswd

sudo docker rm -f tmp-registry

#### ----  3.) Create a Directory to persist Private Docker Registry Data:
# Create a directory on Docker host. 
# We will mount this directory in registry container and it will hold all data pertains to our Private Docker Registry.
#
# By detaching this directory from registry container, we can easily reuse it with other containers derived from registry image. 
# Therefore, if we remove our container, it won’t destroy the data within our Private Docker Registry.
sudo mkdir -p ${DOCKER_REGISTRY_DIR}/registry

#### ----  4.) Create a Private Docker Registry Container on CentOS 7:
# Pull registry image from Docker Hub.
sudo docker pull registry

#Create a container for Private Docker Registry.

#sudo docker run -d \
# (recast) [rsheu@recast-dev-2 docker-registry]$ ./test-registry-ssl.sh 
# DOCKER_REGISTRY_DIR=/opt/docker/containers/docker-registry
# DOCKER_REGISTRY_CERTS_DIR=/opt/docker/containers/docker-registry/certs
# sudo docker run -it -p 5000:5000 --name registry -v /opt/docker/containers/docker-registry/certs:/certs -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/docker-registry.crt -e REGISTRY_HTTP_TLS_KEY=/certs/docker-registry.key -v /opt/docker/containers/docker-registry/registry:/var/lib/registry registry:2

#### -------------------------------------------------------------------------------
#### --- This will provide both BASIC and SSL x509 authentication for pull/push ----
#### -------------------------------------------------------------------------------
sudo docker run -d \
    --name docker-registry \
    --restart=always \
    -p 5000:5000 \
    -v ${DOCKER_REGISTRY_DIR}/registry:/var/lib/registry \
    -v ${DOCKER_REGISTRY_DIR}/auth:/auth \
    -v ${DOCKER_REGISTRY_DIR}/certs:/certs \
    -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/${REGISTRY_CERT} \
    -e REGISTRY_HTTP_TLS_KEY=/certs/${REGISTRY_KEY} \
    -e REGISTRY_AUTH=htpasswd \
    -e REGISTRY_AUTH_HTPASSWD_REALM=Registry_Realm \
    -e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
    registry:2

sudo mkdir -p /etc/docker/certs.d
sudo cp ${DOCKER_REGISTRY_CERTS_DIR}/${REGISTRY_CERT} /etc/docker/certs.d/
sudo service docker restart

#### ---- Setup Client (localhost) to have the cert of the (local) SSL-enabled Registgry ---- ####
#### (remember to do the same to remote Node's Dockder daemon) 
####
# Ok our server side now uses our certs. Great! but we are not done yet.
# In order for clients to be able to connect the registry, we need their workstations to trust our CA. Otherwise, it won't connect. 
# If your client machine already trust your CA certificate, you're done. Else, you need to copy your CA certificate over the machine. 
# You can copy it to /etc/docker/certs.d and docker will trust it automatically, or for the OS to trust it you need to (On Ubuntu system, 
# it may vary on other OS):
#  >>  Make sure to restart the docker service on the client after you do that.
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
    sudo cp ${DOCKER_REGISTRY_CERTS_DIR}/${REGISTRY_CERT} /etc/pki/ca-trust/source/anchors/
    # then run the following command
    sudo update-ca-trust
else
    if [[ "$OS_TYPE" =~ "^Ubuntu" ]]; then
        # Ubuntu
        echo "---- OS Type: $OS_TYPE"
        ## ---- For Ubuntu OS: -----
        # Copy it to /usr/local/share/ca-certificates/
        sudo cp ${DOCKER_REGISTRY_CERTS_DIR}/${REGISTRY_CERT} /usr/local/share/ca-certificates/
        sudo update-ca-certificates
    else
        echo "**** Unsupported OS Type: $OS_TYPE"
    fi
fi


#### ---- 5.) Add IP Address of Private Docker Registry to Local DNS resolver of Docker host
function setupEntryToEtcHosts() {
    sudo cp /etc/hosts /etc/hosts.SAVE.`date +%F`
    echo "----> Adding DNS entry into /etc/hosts: "
    echo "  ${DOCKER_HOST_IP} ${DOCKER_HOST_FQDN} docker-registry"
    cat << EOF | sudo tee -a /etc/hosts
    ${DOCKER_HOST_IP} ${DOCKER_HOST_FQDN} docker-registry
EOF
}
# setupEntryToEtcHosts

#### ---- 6.) Setup SSL foldder for certs for registry ----
# Install digital security certificate on Docker host as follow:
sudo mkdir -p /etc/docker/certs.d/${DOCKER_HOST_FQDN}:5000
sudo cp ${DOCKER_REGISTRY_CERTS_DIR}/certs/${REGISTRY_CERT} /etc/docker/certs.d/${DOCKER_HOST_FQDN}/ca.crt


##### ---- Also, need to open firewall in the host of the SSL-based Docker Registry ----
#sudo firewall-cmd --permanent --add-port=80/tcp
#sudo firewall-cmd --permanent --add-port=5000/tcp
#sudo firewall-cmd --reload
#sudo service docker restart

############# -------- Testing using busybox ------- ###############

#### ---- 7.) Pull an image from Docker Hub. We will later push this image to our Private Docker Registry.

sudo docker pull busybox

# Create another tag for busybox image, so we can push it into our Private Docker Registry.

sudo docker tag busybox:latest ${DOCKER_HOST_FQDN}:5000/busybox

# Login to docker-registry.example.com using docker command.
sudo docker login ${DOCKER_HOST_FQDN}:5000

# Push busybox image to Private Docker Registry.
sudo docker push ${DOCKER_HOST_FQDN}:5000/busybox

# List locally available images of busybox
sudo docker images | grep busybox
