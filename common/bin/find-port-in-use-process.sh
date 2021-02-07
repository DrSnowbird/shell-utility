#!/bin/bash 

if [ $# -lt 1 ]; then 
    echo "--- Usage: $(basename $0) <port_to_find_process> "
    exit 1
fi
#docker-compose down
#docker rm -fv $(docker ps -aq)
PORT_SEARCH=${1}
procs=`sudo lsof -i -P -n | grep ${PORT_SEARCH} | awk '{print $2}'`
for p in "$procs"; do
    echo $p
    echo "sudo kill -9 $p"
    ps -elf |grep " $p"|grep -v grep
done



