#!/bin/bash

# ref: https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/
# ref: https://www.sslshopper.com/article-most-common-openssl-commands.html

if [ $# -lt 3 ]; then
    echo "--- Usage: $(basename $0) <Common_Name: localhost> <OUT_BASENAME: nginx > [<OUT_DIR: ./self-signed-certificate >] "
    echo "--- Need at least two arguments to auto-generate Key & Certificate without Prompots."
    echo "---    Manually inputs is required from you ..."
    echo
fi

DAYS=3650
OUT_DIR=${3:-$PWD/self-signed-certificate}
mkdir -p ${OUT_DIR}

MY_IP=`ip route get 1|awk '{print$NF;exit;}'`

COMMON_NAME=${1:-my-cert}
OUT_BASENAME=${2:-my-cert}

echo "---- Default parameters: ----"
echo "DAYS=$DAYS"
echo "OUT_DIR=$OUT_DIR"
echo "COMMON_NAME=$COMMON_NAME"
echo "OUT_BASENAME=$OUT_BASENAME"
echo

read -p "Are you sure to use default arguments? (Y/N)" -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]; then
    
    ## Command line without Prompts
    # openssl req -x509 -nodes -newkey rsa:2048 -days 365 -keyout ./etc/nginx/ssl/nginx.key -out ./etc/nginx/ssl/nginx.crt -subj /C=US/ST=State/L=Locality/O=Openkbs.org/OU=ai/CN=192.168.0.160
    openssl req -x509 -nodes -newkey rsa:2048 -days ${DAYS} -keyout ${OUT_DIR}/${OUT_BASENAME}.key -out ${OUT_DIR}/${OUT_BASENAME}.crt -subj "/C=US/ST=State/L=Locality/O=Openkbs.org/OU=ai/CN=${COMMON_NAME}"
else
    # openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ./etc/nginx/ssl/nginx.key -out ./etc/nginx/ssl/nginx.crt
    openssl req -x509 -nodes -days ${DAYS} -newkey rsa:2048 -keyout ${OUT_DIR}/${OUT_BASENAME}.key -out ${OUT_DIR}/${OUT_BASENAME}.crt
fi

## -- Prevent Public access of Key --
sudo chmod 0500 ${OUT_DIR}/${OUT_BASENAME}.key
sudo chmod 0555 ${OUT_DIR}/${OUT_BASENAME}.crt

echo "................... Print out: ${OUT_BASENAME}.crt ........................."
openssl x509 -in ${OUT_DIR}/${OUT_BASENAME}.crt -text -noout
