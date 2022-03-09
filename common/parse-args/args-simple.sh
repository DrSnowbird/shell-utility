#!/bin/bash

# set -e

# ref: https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
#
# (simple template for arg parse)
# Use: Just modify the case's choices to meet you needs
#
# Test:
#  ./args-simple.sh pos1_var -a -b val1 pos2_arg
#
#  MY_FLAG: -a : 0
#  MY_FLAG_ARG: -b : val1
#  remiaing args:
#  pos1_var pos2_arg

PARAMS=""
while (( "$#" )); do
  case "$1" in
    -a|--my-boolean-flag)
      MY_FLAG=0
      shift
      ;;
    -b|--my-flag-with-argument-value)
      if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        MY_FLAG_ARG=$2
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

echo "MY_FLAG: -a : $MY_FLAG"
echo "MY_FLAG_ARG: -b : $MY_FLAG_ARG"
echo "remiaing args:"
echo $*

