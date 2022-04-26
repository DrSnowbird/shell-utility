#!/bin/bash 

#### Usage: copy the following function to your specific script file

#### --------------------------------------------------- ####
#### ---- (ref: https://stackoverflow.com/questions/59895/get-the-source-directory-of-a-bash-script-from-within-the-script-itself)
#### --------------------------------------------------- ####

function findMyAbsDir() {
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
      DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
      SOURCE="$(readlink "$SOURCE")"
      [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    MY_ABS_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
}
# findMyAbsDir
MY_ABS_DIR=$(dirname "$(readlink -f "$0")")
echo -e ">>> MY_ABS_DIR=${MY_ABS_DIR}"
