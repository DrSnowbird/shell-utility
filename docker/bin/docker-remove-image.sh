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
        #exit 1
    fi
}

error_args_needed $0 $@

containers_found=""
find_containers() {
    error_args_needed "find_containers" $1
    containers_found=`docker ps -a|grep $1|awk '{print $1}'`
}

image_name="${1:-<none>}"

images_to_clear=""
containers_to_stop=""

addToImageList() {
    msg ">>>>>> addToImageList: $1"
    found=`echo $images_to_clear|grep $1`
    if [ "x$found" == "x" ]; then
        images_to_clear="$images_to_clear $1"
        msg "-----> Added image id: $1"
        msg "-----> images_to_clear: $images_to_clear"
    else
        msg "-----> Ignore duplicated image id: $1"
    fi
}

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

#### ---- Using Image search pattern to find all the IMAGE_ID and IMAGE_NAME as list ----
image_names=""
findImageNameAndIDList() {
    image_names=""
    msg ">>>>>> findImageNameAndIDList: $@"
    error_args_needed "findImageNameAndIDList" $1
    images="`docker images|grep ${1}|awk '{print $3}'|xargs`"
    for i in $images; do
        msg "image id to clear: $i" 
        addToImageList $i
    done
 
    names="`docker images|grep ${1}|awk '{print $1}'|sort -u | xargs`"
    for i in $names; do
        msg "----> image name for search 'containers instances': $i" 
        found=`echo "$image_names"|grep $i`
        msg "----> search for image names: $i"
        msg "$found"
        if [ "x$found" == "x" ]; then
            image_names="$image_names $i"
        fi
    done
}

find_containersByImagesID() {
    msg ">>>>>> find_containersByImagesID: $@"
    error_args_needed "find_containersByImagesID" $1
    #images="`docker images|grep openkbs/jre-mvn-py3|awk '{print $3}'|xargs`"
    images="`docker images|grep ${1}|awk '{print $3}'|xargs`"
    #images="`docker images|grep ${image_name}|awk '{print $3}'`"
    for i in $images; do
        msg "----> image to clear: $i" 
        #images_to_clear="$images_to_clear $i"
        addToImageList $i

        ##containers=`docker ps -a|grep d9ea2fa396a4|awk '{print $1}'`    
        ##containers=`docker ps -a|grep $i|awk '{print $1}'`    
        find_containers $i
        containers="$containers_found"
        msg "   containers: $containers"
        for j in $containers; do
            msg "----> container to stop: $j"
            #containers_to_stop="$containers_to_stop $j"
            addToContainerList "$j"
        done
    done
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
    images="`docker ps -a|grep ${1}|awk '{print $2}'`"
    for i in $images; do
        msg "----> images to add into clear list: $j"
        findImageNameAndIDList $i
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

removeImages() {
    echo ">>>>>> removeImages: $@"
    image_tag_list=""
    for i in $images_to_clear; do
        imageTagName=`docker images|grep $i|awk '{print $1":"$2}'`
        none_name=`echo ${imageTagName}|grep "none"`
        if [ ! "x$none_name" == "x" ]; then
            imageTagName=$i
        fi
        found=`echo "$image_tag_list"|grep $imageTagName`
        if [ "x$found" == "x" ]; then
            image_tag_list="$image_tag_list $imageTagName"
        fi
    done
    for k in $image_tag_list; do
        echo "----> images to clear : $k"
        if [ $action -gt 0 ]; then
            docker rmi -f $k
        fi
        echo "----> docker rmi -f $k"
    done
}

find_containersByImagesID "$image_name"

find_containersByNames "$image_name"

echo "---------- remove Containers & Images -----------"
echo ">>>>> > images_to_clear= $images_to_clear"
echo "-------------------------------------------------"
echo ">>>>>>  containers_to_stop= $containers_to_stop"
echo "-------------------------------------------------"

removeContainers
removeImages

docker images
docker ps -a
