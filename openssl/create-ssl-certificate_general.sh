#!/bin/bash -x

# ref: https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/
# ref: https://www.sslshopper.com/article-most-common-openssl-commands.html

if [ $# -lt 3 ]; then
    echo "--- Usage: $(basename $0) <Common_Name: host name> <OUT_BASENAME: my-cert > [<OUT_DIR: ./self-signed-certificate >] "
    echo "--- Need at least two arguments to auto-generate Key & Certificate without Prompts."
    echo "--- >> Manually inputs is required from you if you choose to do so (N: not accept default) when prompt."
    echo
fi

OUT_DIR=${3:-$PWD/self-signed-certificate}

#MY_IP=`ip route get 1|awk '{print$NF;exit;}'`
MY_IP=`hostname -I | awk '{print $1}'`

OUT_BASENAME=${2:-my-cert}
mkdir -p ${OUT_DIR}

SSL_COUNTRY=${SSL_COUNTRY:-Country}
SSL_STATE=${SSL_STATE:-State}
SSL_LOCALITY=${SSL_LOCALITY:-City}
SSL_ORG=${SSL_ORG:-Org}
COMMON_NAME=${COMMON_NAME:-`hostname -f`}

DAYS=3650

echo "---- Default parameters: ----"
echo "OUT_BASENAME=$OUT_BASENAME"
echo "DAYS=$DAYS"
echo "OUT_DIR=$OUT_DIR"
echo "COMMON_NAME=$COMMON_NAME"
echo

read -p "Are you sure to use default arguments? (Y/N)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    openssl req  \
   -newkey rsa:2048 \
   -nodes -sha256 \
   -x509 -days 3650 \
   -keyout ${OUT_DIR}/${OUT_BASENAME}.key \
   -out ${OUT_DIR}/${OUT_BASENAME}.crt \
   -subj "/C=${SSL_COUNTRY}/ST=${SSL_STATE}/L=${SSL_LOCALITY}/O=${SSL_ORG}/CN=${COMMON_NAME}"

    ls -al ${OUT_DIR}/certs
    
    ## Command line without Prompts
    # openssl req -x509 -nodes -newkey rsa:2048 -days 365 -keyout ./etc/nginx/ssl/nginx.key -out ./etc/nginx/ssl/nginx.crt -subj /C=US/ST=State/L=Locality/O=Openkbs.org/OU=ai/CN=192.168.0.160

else
    # openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./etc/nginx/ssl/nginx.key -out ./etc/nginx/ssl/nginx.crt
    openssl req -x509 -nodes -days ${DAYS} -newkey rsa:2048 -keyout ${OUT_DIR}/${OUT_BASENAME}.key -out ${OUT_DIR}/${OUT_BASENAME}.crt
fi

## -- Prevent Public access of Key --
sudo chmod 0500 ${OUT_DIR}/${OUT_BASENAME}.key
sudo chmod 0555 ${OUT_DIR}/${OUT_BASENAME}.crt

echo "................... Print out: ${OUT_BASENAME}.crt ........................."
openssl x509 -in ${OUT_DIR}/${OUT_BASENAME}.crt -text -noout
