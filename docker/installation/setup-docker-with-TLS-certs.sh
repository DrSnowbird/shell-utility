#!/bin/bash -x

#!/bin/bash
#see https://docs.docker.com/engine/security/https/

CA_SUBJECT_STRING="/C=US/ST=VA/L=City/O=Org/OU=Org/CN=${HOST_NAME}/emailAddress=user1@company.org"

while [[ $# -gt 1 ]]
do
key="$1"

case $key in
    -h|--hostname)
    HOST_NAME="$2"
    shift
    ;;
    -hip|--hostip)
    HOST_IP="$2"
    shift
    ;;
    -pw|--password)
    CA_PASSWD="$2"
    shift
    ;;
    -t|--targetdir)
    CERTS_DIR="$2"
    shift
    ;;
    -e|--expirationdays)
    EXPIRATION_DAYS="$2"
    shift
    ;;
    --ca-subj)
    CA_SUBJECT_STRING="$2"
    shift
    ;;
    *)
            # unknown option
    ;;
esac
shift
done

#You can create these files as described in the official docs in Protect the Docker daemon socket.

CA_PASSWD=${CA_PASSWD:-mySecret12345}
HOST_NAME=`hostname -f`
HOST_IP=`hostname -I | awk '{print $1}' `
CERTS_DIR=${CERTS_DIR:-./certs}
EXPIRATION_DAYS=${EXPIRATION_DAYS:-3650}

echo "----- debug: -----"
echo "CA_PASSWD=${CA_PASSWD}"
echo "HOST_NAME=${HOST_NAME}"
echo "HOST_IP=$HOST_IP"
echo "CERTS_DIR=${CERTS_DIR}"
echo "EXPIRATION_DAYS=${EXPIRATION_DAYS}"

if [ ! -d ${CERTS_DIR} ]; then
    mkdir -p ${CERTS_DIR}
fi

function create_CA {
    openssl genrsa -aes256 -passout pass:${CA_PASSWD} -out ${CERTS_DIR}/ca-key.pem 4096
    openssl req -passin pass:${CA_PASSWD} -new -x509 -days ${EXPIRATION_DAYS} -key ${CERTS_DIR}/ca-key.pem -sha256 -out ${CERTS_DIR}/ca.pem -subj ${CA_SUBJECT_STRING}

    chmod 0400 ${CERTS_DIR}/ca-key.pem
    chmod 0444 ${CERTS_DIR}/ca.pem
}

function checkCAFilesExist {
    if [[ ! -f "${CERTS_DIR}/ca.pem" || ! -f "${CERTS_DIR}/ca-key.pem" ]]; then
        echo "${CERTS_DIR}/ca.pem or ${CERTS_DIR}/ca-key.pem not found. Create CA first with '-m ca'"
        exit 1
    fi
}

function create_ServerCert {
    checkCAFilesExist

    if [[ -z $HOST_IP ]]; then
        IP_STRING=""
    else
        IP_STRING=",IP:$HOST_IP"
    fi

    openssl genrsa -out ${CERTS_DIR}/server-key.pem 4096
    openssl req -subj "/CN=${HOST_NAME}" -new -key ${CERTS_DIR}/server-key.pem -out ${CERTS_DIR}/server.csr
    echo "subjectAltName = DNS:${HOST_NAME}${IP_STRING}" > ${CERTS_DIR}/extfile.cnf
    openssl x509 -passin pass:${CA_PASSWD} -req -days ${EXPIRATION_DAYS} -in ${CERTS_DIR}/server.csr -CA ${CERTS_DIR}/ca.pem -CAkey ${CERTS_DIR}/ca-key.pem -CAcreateserial -out ${CERTS_DIR}/server-cert.pem -extfile ${CERTS_DIR}/extfile.cnf

    rm ${CERTS_DIR}/server.csr ${CERTS_DIR}/extfile.cnf ${CERTS_DIR}/ca.srl
    chmod 0400 ${CERTS_DIR}/server-key.pem
    chmod 0444 ${CERTS_DIR}/server-cert.pem
}

function create_ClientCert {
    checkCAFilesExist

    openssl genrsa -out ${CERTS_DIR}/client-key.pem 4096
    openssl req -subj "/CN=${CN_HOST}" -new -key ${CERTS_DIR}/client-key.pem -out ${CERTS_DIR}/client.csr
    echo "extendedKeyUsage = clientAuth" > ${CERTS_DIR}/extfile.cnf
    openssl x509 -passin pass:${CA_PASSWD} -req -days ${EXPIRATION_DAYS} -in ${CERTS_DIR}/client.csr -CA ${CERTS_DIR}/ca.pem -CAkey ${CERTS_DIR}/ca-key.pem -CAcreateserial -out ${CERTS_DIR}/client-cert.pem -extfile ${CERTS_DIR}/extfile.cnf

    rm ${CERTS_DIR}/client.csr ${CERTS_DIR}/extfile.cnf ${CERTS_DIR}/ca.srl
    chmod 0400 ${CERTS_DIR}/client-key.pem
    chmod 0444 ${CERTS_DIR}/client-cert.pem

    mv ${CERTS_DIR}/client-key.pem ${CERTS_DIR}/client-${CN_HOST}-key.pem
    mv ${CERTS_DIR}/client-cert.pem ${CERTS_DIR}/client-${CN_HOST}-cert.pem
}

echo "----------------------------------------------------------------------"
#### 1.) Create a CA with the password ${CA_PASSWD} and 900 days until it wil expire. The cert files will be in the directory ./certs.
#### ---- generate files:
# - CA key
# - CA certificate
# -r-------- 1 rsheu rsheu 3326 Oct 27 17:34 ca-key.pem
# -r--r--r-- 1 rsheu rsheu 2086 Oct 27 17:34 ca.pem

#~/bin/create-certs-TLS.sh -m ca -pw ${CA_PASSWD} -t certs -e ${EXPIRATION_DAYS}
create_CA

echo "----------------------------------------------------------------------"
#### 2.) Create server certificate and key with the password of step 1 ${CA_PASSWD}, with the servername myserver.example.com and 365 days until it wil expire. The cert files will be in the directory ./certs.
#### ---- generate files:
# - Server certificate
# - Server key
# -r--r--r-- 1 rsheu rsheu 1891 Oct 27 17:35 server-cert.pem
# -r-------- 1 rsheu rsheu 3243 Oct 27 17:35 server-key.pem

#~/bin/create-certs-TLS.sh -m server -h ${HOST_NAME} -hip ${HOST_IP} -pw ${CA_PASSWD} -t certs -e ${EXPIRATION_DAYS}
create_ServerCert

ls -al ${CERTS_DIR}

#### 3. - optional) Create client certificate and key with the password of step 1 ${CA_PASSWD}, with the clientname testClient (the name is interesting if you want to use authorization plugins later) and 365 days until it wil expire. The cert files will be in the directory ./certs.
echo "----------------------------------------------------------------------"
echo "... If you want to create Client certificates, do the following: "
echo create_ClientCert

echo
echo "----------------------------------------------------------------------"
echo "Now you have a directory ./certs with certificates and keys for CA, server and client"
ls -al ./certs

DOCKER_CERTS_DIR=/etc/docker/certs_docker
DOCKER_DAEMON_JSON=/etc/docker/daemon.json
sudo  mkdir -p ${DOCKER_CERTS_DIR}
sudo  cp ./certs/* ${DOCKER_CERTS_DIR}/
if [ -s ${DOCKER_DAEMON_JSON} ]; then
    sudo cp --backup=numbered ${DOCKER_DAEMON_JSON} ${DOCKER_DAEMON_JSON}.saved
fi

#### To debug dockerd daemon, add the debug into JSON file
#    "debug": true,
#
cat <<EOF | sudo tee $DOCKER_DAEMON_JSON
{
    "tls": true,
    "tlscert": "$DOCKER_CERTS_DIR/server-cert.pem",
    "tlskey": "$DOCKER_CERTS_DIR/server-key.pem",
    "hosts": [
        "unix:///var/run/docker.sock",
        "tcp://0.0.0.0:2376"
    ]
}
EOF

#### Need to overide docker.conf file to avoid the "hosts" conflict above 
DOCKER_CONFIG=/etc/systemd/system/docker.service.d/docker.conf
if [ -s ${DOCKER_CONFIG} ]; then
    sudo cp --backup=numbered ${DOCKER_CONFIG} ${DOCKER_CONFIG}.saved
else
    if [ ! -d $(dirname ${DOCKER_CONFIG}) ]; then
        sudo mkdir -p $(dirname ${DOCKER_CONFIG})
    else
        ls -al $(dirname ${DOCKER_CONFIG})
    fi
fi

cat <<EOF | sudo tee $DOCKER_CONFIG
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF

ls -al ${DOCKER_CONFIG}
cat $DOCKER_CONFIG

sudo systemctl daemon-reload
sleep 4
sudo systemctl start docker
sleep 4
sudo systemctl status docker

