#!/bin/bash

# source: https://stackoverflow.com/questions/16758105/list-all-graphic-image-files-with-find

FOLDER=${1:-.}
#find ${FOLDER} -type f -exec file --mime-type {} \+ | awk -F: '{if ($2 ~/image\//) print $1}'
#find ${FOLDER} -type f -exec file {} \; | grep -o -P '^.+: \w+ image'

# (good coverage)
#find . -type f -print0 | 
#    xargs -0 file --mime-type | 
#    grep -F 'image/' |
#    rev | cut -d ':' -f 2- | rev

# (super fast)
find . -type f -print0 |
    xargs -0 file --mime-type |
    grep -F 'image/' |
    cut -d ':' -f 1
