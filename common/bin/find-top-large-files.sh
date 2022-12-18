#!/bin/bash 

## -- main -- ##

set -e

function usage() {
    if [ $# -lt 2 ]; then
        echo -e "**** ERROR: $(basename $0): Need two (optional) arguments: [-d <dir> ] [-t <#_of_top_files>]"
    fi
}
usage $*

#
PARAMS=""
## -- directory: to search large files: -- ##
dir="./"
## -- top N files (size): -- ##
top=10
while (( "$#" )); do
  case "$1" in
    -d|--dir)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        dir=$2
        shift 2
      else
        echo "Error: Argument for $1 is missing value" >&2
        exit 1
      fi
      ;;
    -t|--top)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        top=$2
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

echo "dir: ${dir}"
echo "top (N file): ${top}"
echo "remiaing args:"
echo $*

du -a ${dir} | sort -n -r | head -n ${top}
