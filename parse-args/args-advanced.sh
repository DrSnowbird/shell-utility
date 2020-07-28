#!/bin/bash

# set -e

##########################################################################
# ref: https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
#
# (simple template for arg parse)
# Use: Just modify the case's choices to meet you needs
#
# Test:
#  ./args-advanced.sh -s -a install -t generic -d remiaing args: code-extensions.txt
#
# ---> args: -a install -t generic -d remiaing args: code-extensions.txt
# OK: value: install: 
#  matched list: install run
# ---> args: -t generic -d remiaing args: code-extensions.txt
# OK: value: generic: 
#  matched list: generic package distribution
# ---- parsed args: ---
# OK: value: generic: 
#  matched list: generic package distribution
# ACTION: -a : install
# INSTALL_TYPE: -t : generic
# remiaing args: remiaing args: code-extensions.txt
#
##########################################################################

function usage() {
    echo "-- usage --"
    echo -e " $(basename $0)             \n \
    [ -s|--server : (default) Install Server or not \n \
    [ -d|--desktop : Install desktop or not \n \
        (either VS Code or Code-Server; -s and -d are mutual exclusive) ] \n \
    [ -a|--action : {install, run}] : default=install     \n \
    [ -t|--install-type : {              \n \
        generic : (*.tar.gz),            \n \
        package : (*.deb, or *.rpm),     \n \
        distribution : (auto-detect OS to install) } : default=generic ]
    "
    _ALLOWD_VALUES="generic package distribution"
}

# 0: false; 1: true (ok)
_ARG_VALIDATE=0
_ALLOWD_VALUES=""
function _aux_validate_values() {
    _ARG_VALIDATE=0
    if [ "$_ALLOWD_VALUES" != "" ]; then
        for allowed in $_ALLOWD_VALUES ; do
            if [ "$allowed" = "$1" ]; then
                echo -e "OK: value: $1: \n matched list: $_ALLOWD_VALUES"
                _ARG_VALIDATE=1
            fi
        done
    else
        _ARG_VALIDATE=1
    fi
}


_ARG_VALUE=""
function _aux_arg_process() {
    echo "---> args: $@"
    _ARG_VALUE=""
    if [ -n "$2" ] && [ ${2:0:1} != "-" ]; then
        _ARG_VALIDATE=0
        _aux_validate_values $2 $_ALLOWD_VALUES
        if [ $_ARG_VALIDATE -gt 0 ]; then
            _ARG_VALUE=$2
        else
            echo -e "Error: Argument for $1 is NOT ALLOWED: \n        acceptable are: $_ALLOWD_VALUES" >&2
        fi
    else
        usage
        echo "Error: Argument for $1 is missing value" >&2
        exit 1
    fi
}

#### ---- default values ----
ACTION="install"
INSTALL_TYPE="generic"
INSTALL_SERVER=1

PARAMS=""
while (( "$#" )); do
    _ARG_VALUE=""
    _ALLOWD_VALUES=""
    case "$1" in
        -s|--server)
            INSTALL_SERVER=1
            shift
            ;;
        -d|--desktop)
            INSTALL_SERVER=0
            shift
            ;;
        -a|--action)
            _ALLOWD_VALUES="install run"
            _aux_arg_process "$@"
            if [ "$_ARG_VALUE" != "" ]; then
                ACTION=$_ARG_VALUE
                shift 2
            fi
            ;;
        -t|--install-type)
            _ALLOWD_VALUES="generic package distribution"
            _aux_arg_process "$@"
            if [ "$_ARG_VALUE" != "" ]; then
                INSTALL_TYPE=$_ARG_VALUE
                shift 2
            fi
            ;;
        -*|--*=) # unsupported flags
            echo "Error: Unsupported flag $1" >&2
            usage
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
echo "---- parsed args: ---"
echo "ACTION: -a : $ACTION"
echo "INSTALL_TYPE: -t : $INSTALL_TYPE"
echo "INSTALL_SERVER: -s : $INSTALL_SERVER"
echo "remiaing args: $*"
