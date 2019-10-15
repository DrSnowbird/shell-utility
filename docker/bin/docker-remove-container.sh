#!/bin/bash 

action=1
debug=0
msg() {
    if [ $debug -eq 1 ]; then
        echo "$*"
    fi
}

error_args_needed() {
    if [ $# -lt 2 ]; then
        echo "---ERROR: $1: need provide image tag pattern!"
        exit 1
    fi
}

error_args_needed $0 $@

image_name="${1}"

containers_to_stop=""

addToContainerList() {
    msg ">>>>>> addToContainerList: $1"
    error_args_needed "addToContainerList" $1
    found=`echo $containers_to_stop|grep $1`
    if [ "x$found" == "x" ]; then
        containers_to_stop="$containers_to_stop $1"
        msg "----> Added container id: $1"
        msg "----> containers_to_stop: $containers_to_stop"
    else
        msg "----> Ignore duplicated container id: $1"
    fi
}

find_containersByNames() {
    msg ">>>>>> find_containersByNames: $@"
    error_args_needed "find_containersByNames" $1
    #images="`docker images|grep openkbs/jre-mvn-py3|awk '{print $3}'|xargs`"
    containers="`docker ps -a|grep ${1}|awk '{print $1}'`"
    for j in $containers; do
        msg "----> container to stop: $j"
        #containers_to_stop="$containers_to_stop $j"
        addToContainerList "$j"
    done
}

removeContainers() {
    echo ">>>>>> removeContainers: $@"
    for i in $containers_to_stop; do
        if [ $action -gt 0 ]; then
            docker stop $i
            docker rm $i
        fi
        echo "----> docker stop $i"
        echo "----> docker rm $i"
    done
}

find_containersByNames "$image_name"

echo "---------- remove Containers & Images -----------"
echo ">>>>>>  containers_to_stop= $containers_to_stop"
echo "-------------------------------------------------"

removeContainers

docker ps -a

