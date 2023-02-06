#!/bin/bash 

#if [ $# -lt 1 ]; then
#    echo "Usage: "
#    echo "  ${0} <image_id>"
#    echo -e "$0 <Docker-parent-image-ID_or_image-Name>"
#    exit 1
#fi

CONT_YES=0
function askToContinue() {
    PROMPT=${1:-"Are you sure to continue (Yes/No)?"}
    read -p "$PROMPT" -n 1 -r
    #read -p "Are you sure to continue (Yes/No)?" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo ".... do dangerous stuff"
    else
        CONT_YES=0
        exit 0
    fi
}
#echo $CONT_YES
#askToContinue

#### ---- Usage ---- ####
function usage() {
    echo "-------------- Usage --------------------------------------------------------------------"
    echo -e "$0 [-d (delete child images)] <Parent image-ID or image-Name>"
    echo -e "default is to just 'list child images only - NOT delete!"
    echo "SHORT=hdlo:"
    echo "LONG=help,delete,list,output:"
    echo "-----------------------------------------------------------------------------------------"
}

if [ $# -lt 1 ]; then
    usage
    exit 1
fi

ORIG_ARGS="$*"

DELETE_IMAGES=0

SHORT="hdlo:"
LONG="help,delete,output:"

#PARSED=$(getopt --options ${SHORT} --longoptions ${LONG} --name "$0" -a -- "$@")
PARSED=$(getopt -o ${SHORT} -l ${LONG} --name "$0" -a -- "$@")

if [[ $? != 0 ]]; then
    echo "Parsing Error! Abort!"
    exit 1
fi
eval set -- "${PARSED}"

while true
do
    case "$1" in
        -h|--help)
            usage
            ;;
        -d|--delete)
            # delete the root and child images found
            DELETE_IMAGES=1
            echo "DELETE_IMAGES=$DELETE_IMAGES"
            ;;
        -l|--list)
            # list the root and child images found
            DELETE_IMAGES=0
            echo "DELETE_IMAGES=$DELETE_IMAGES"
            ;;
        -o|--output)
            shift
            OUTPUT_FILE=$1
            echo "OUTPUT_FILE=$OUTPUT_FILE"
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "*****: input args error"
            echo "$ORIG_ARGS"
            exit 3
            ;;
    esac
    shift
done

echo "-------------"
echo "ORIGINAL INPUT >>>>>>>>>>:"
echo "${ORIG_ARGS}"

echo "-------------"
echo "After Parsing: INPUT >>>>>>>>>>:"
echo "$@"

#### ---------------
#### ---- MAIN: ----
#### ---------------
#### (ref)
#### -f, --filter value    Filter output based on conditions provided (default [])
####                         - dangling=(true|false)
####                         - label=<key> or label=<key>=<value>
####                         - before=(<image-name>[:tag]|<image-id>|<image@digest>)
####                         - since=(<image-name>[:tag]|<image-id>|<image@digest>)
####                         - reference=(pattern of an image reference)

echo "..... Start your main code here .............."
tmpfile="./tmp123.txt"
rm -f $tmpfile

IMAGE_ID=${1}

docker inspect --format='{{.RepoTags}} {{.Created}}' --type=image ${IMAGE_ID} >> $tmpfile
#docker inspect --format='{{.RepoTags}} {{.Created}}' --type=image ${IMAGE_ID} | cut -d':' -f1 |cut -d'[' -f2 | tee -a $tmpfile
#docker inspect --format='{{.RepoTags}}' --type=image ${IMAGE_ID} | cut -d':' -f1 |cut -d'[' -f2 | tee -a $tmpfile

CHILD_IMAGES=$(docker inspect --format='{{.Id}} {{.Parent}}' $(docker images --filter since=${IMAGE_ID} -q)|cut -d':' -f2|cut -c-12)
echo -e ">>> CHILD_IMAGES of ${IMAGE_ID}:\n------------\n${CHILD_IMAGES}"
echo -e "----------- (end of child images)"

echo ${CHILD_IMAGES} | while read __IMAGE_ID; do
    docker inspect --format='{{.RepoTags}} {{.Created}}' --type=image ${__IMAGE_ID} >> $tmpfile
    #docker inspect --format='{{.RepoTags}} {{.Created}}' --type=image ${__IMAGE_ID} | cut -d':' -f1 |cut -d'[' -f2 | tee -a $tmpfile
    #docker inspect --format='{{.RepoTags}}' --type=image ${__IMAGE_ID} | cut -d':' -f1 |cut -d'[' -f2) | tee -a $tmpfile
    #CHILD_IMAGE_NAMES+=( $_IMAGE_NAME )
    #echo ${CHILD_IMAGE_NAMES}
    #echo "-------------"
done
CHILD_IMAGE_NAMES=$(cat $tmpfile)
rm -f $tmpfile

echo -e ">>>> --------------------------------------------------------"
echo -e ">>>> ------------ ROOT+CHILD IMAGES to DELETE: --------------"
echo -e ">>>> --------------------------------------------------------"
echo -e "${CHILD_IMAGE_NAMES}"


if [ ${DELETE_IMAGES} -gt 0 ]; then
    echo -e ">>>> ---------------------------------------------------------------------------"
    echo -e ">>>> Are you sure to DELETE the above Docker images (root and all child iamges)?"
    echo -e ">>>> The DELETE Operation Can't be un-done!"
    echo -e ">>>> (If you are sure, then enter Yes/Y to proceed)"
    echo -e ">>>> ---------------------------------------------------------------------------"
    askToContinue
    if [ $CONT_YES -lt 1 ]; then
        echo -e ">>> INFO: ... You choose to abort Delete Images! "
        exit 0
    fi
    exit 0
    
    if [ "${CHILD_IMAGES}" != "" ]; then
        # docker inspect --format='{{.Id}} {{.Parent}}' ${CHILD_IMAGES}
        # docker rmi -f $(docker inspect --format='{{.Id}} {{.Parent}}' $(docker images --filter since=${IMAGE_ID} -q)|cut -d':' -f2|cut -c-12)
        #echo $CONT_YES
        docker rmi -f ${CHILD_IMAGES}
        fi
    else
        echo -e "--- Not finding any related CHILD_IMAGES ID ..."
    fi
    docker rmi -f ${IMAGE_ID}
fi
echo -e "===================== Done ===================="
echo -e ""

