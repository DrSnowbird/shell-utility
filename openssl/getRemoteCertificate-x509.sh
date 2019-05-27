#!/bin/bash -x

remote_svr_ip=${1:-127.0.0.1}

remote_svr_port=${2:-443}

# With SNI
#If the remote server is using SNI (that is, sharing multiple SSL hosts on a single IP address) you will need to send the correct hostname in order to get the right certificate.

#openssl s_client -showcerts -servername ${remote_svr_ip} -connect ${remote_svr_ip}:${remote_svr_port} </dev/null

# Without SNI
#If the remote server is not using SNI, then you can skip -servername parameter:

#openssl s_client -showcerts -connect ${remote_svr_ip}:${remote_svr_port} </dev/null


# To view the full details of a site's cert you can use this chain of commands as well:
echo | openssl s_client -servername ${remote_svr_ip} -connect ${remote_svr_ip}:${remote_svr_port} 2>/dev/null | \
    openssl x509 -text
