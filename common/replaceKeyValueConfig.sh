#!/bin/bash 

################################ Usage #######################################
## --------------------------------------------------------------------------
## Usage: When run: ./replaceKeyValueConfig.sh try.conf KEY1 BBBBB
##   The result will on replace "KEY1   =  AAAAA" to "KEY1    = BBBBB"
##
## -- example file below ----
#### Comment line should be igored by parser for replacement (leave it alone!)
#### Parital (subsuming) matches should be ignored also
#### Bland space in between or front should be ignored.

# KEY1=1111
    KEY123 = 123
KEY1   =  AAAAA
## --------------------------------------------------------------------------

## -- main -- ##

set -e

if [ $# -lt 3 ]; then
    echo "**** ERROR: $(basename $0): missing two args: <FILE> <KEY> <NEW_VALUE>"
    exit 1;
fi
FILE=${1}
KEY=${2}
VALUE=${3}
search=`cat $FILE|grep "$KEY"`
if [ "$search" = "" ]; then
    echo "-- Not found: Append into the file"
    echo "$KEY=$VALUE" >> $FILE
else
    sed -i 's/^[[:blank:]]*\('$KEY'[[:blank:]]*=\).*/\1'$VALUE'/g' $FILE
fi

cat $FILE |grep $KEY
