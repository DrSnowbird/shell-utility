#!/bin/bash

echo ">>>> Convert MOV (Apple's Movie / video) format to mp4 ..."
echo "Usage:"
echo "    $(basename $0) <input e.g., in-file.mov> <out-file.mp4>"
if [ $# -lt 2 ]; then
    echo "**** ERROR: please provide <input e.g., in-file.mov> <out-file.mp4>"
    exit 1
fi

MOV_FILE=${1}
MP4_FILE=${2}
ffmpeg -i ${MOV_FILE} -c copy ${MP4_FILE}
