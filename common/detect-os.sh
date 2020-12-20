#!/usr/bin/env bash
##!/bin/bash -x

# ref: https://gist.github.com/prabirshrestha/3080525

function detect_os() {
    UNAME=$( command -v uname)
    OS_ID=
    OS_VER=
    case $( "${UNAME}" | tr '[:upper:]' '[:lower:]') in
      linux*)
        printf 'linux\n'
        # remove all double quotes: echo "${opt//\"}"
        OS_ID=$(awk -F= '/^ID=/{print $2}' /etc/os-release)
        OS_VER=$(awk -F= '/^VERSION_ID=/{print $2}' /etc/os-release | tr -d '"')
        echo "$OS_ID"
        echo "$OS_VER"
        ;;
      darwin*)
        printf 'darwin\n'
        ;;
      msys*|cygwin*|mingw*)
        # or possible 'bash on windows'
        printf 'windows\n'
        ;;
      nt|win*)
        printf 'windows\n'
        ;;
      *)
        printf 'unknown\n'
        ;;
    esac
}
detect_os
    
