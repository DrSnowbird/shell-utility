#!/bin/bash 

function usage() {
    echo "------ Usage: ------"
    echo "$(basename $0) [-d <max_depth>: default=3] [<directory_to_search>: default='./']"
}

DIR_FIND=.
MAX_DEPTH=3

# Test:
#  ./args-simple.sh pos1_var -a -b val1 pos2_arg
#
#  depth: -d : 0
#  MY_FLAG_ARG: -b : val1
#  remiaing args:
#  pos1_var pos2_arg

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -h|--level|--depth)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MAX_DEPTH=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing value" >&2
        exit 1
      fi
      ;;
    -*|--*=) # unsupported flags
      echo "Error: Unsupported flag $1" >&2
      exit 1
      ;;
    *) # preserve positional arguments
      PARAMS="$PARAMS $1"
      shift
      ;;
  esac
done
# set positional arguments in their proper place
eval set -- "$PARAMS"
if [ $# -gt 0 ]; then
    DIR_FIND=$*
fi
echo "DIR_FIND: -d : $DIR_FIND"
echo "MAX_DEPTH: -h : $MAX_DEPTH"
echo "remiaing args:"
echo $*

# ----------------------------------------------------------------------------------
# credits go to: https://github.com/Hoppi164/list_file_extensions/blob/master/lfe.sh
# Author: https://github.com/Hoppi164
# ----------------------------------------------------------------------------------
for d in ${DIR_FIND}; do
    echo -e "============================================================="
    echo -e "------ Tree View: dir= $d "
    tree -L ${MAX_DEPTH}
    echo -e "------ File Statistics: dir= $d "
    find $d -maxdepth ${MAX_DEPTH} -type f \
        | tr '[:upper:]' '[:lower:]' \
        | grep -E ".*\.[a-zA-Z0-9]*$" \
        | sed -e 's/.*\(\.[a-zA-Z0-9]*\)$/\1/' \
        | sort \
        | uniq -c \
        | sort -n
done
