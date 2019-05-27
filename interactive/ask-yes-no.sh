#!/bin/bash 

# ------------------------------------ 
# maintainer: DrSnowbird@openkbs.org
# license: Apache License Version 2.0
# ------------------------------------ 

echo "--------------------------------------------"
echo "##### Way-1: Ask Yes/No with default Y #####"
echo "--------------------------------------------"
## arg1: "Prompt String, e.g. Enter choice (Y/n) default=Y? "
## arg2: Default value, Y (default) or N
answer=y
function askYesNo1() {
    #read -n 1 -p "Enter choice (Y/n) default=Y? " answer
    read -n 1 -p "$1" answer
    # if echo "$answer" | grep -iq "^y" ;then
    if [ "$answer" == "${answer#[Nn]}" ] ;then
        echo "===> Yes (you enter $answer)"
    else
        echo "===> No (you enter $answer)"
    fi
}
askYesNo1 "Enter choice (Y/n) default=Y? "

echo "--------------------------------------------"
echo "##### Way-2: Ask Yes/No with default Y #####"
echo "--------------------------------------------"
## arg1: "Prompt String, e.g. Enter choice (Y/n) default=Y? "
## arg2: Default value, Y (default) or N
answer=y
function askYesNo2() {
    #read -n 1 -p "Enter choice (Y/n) default=Y? " answer
    read -n 1 -p "$1" answer
    case ${answer:0:1} in
        n|N )
            echo "===> No (you enter $answer)"
        ;;
        * )
            echo "===> Yes (you enter $answer)"
        ;;
    esac
}
askYesNo2 "Enter choice (Y/n) default=Y? "

echo "--------------------------------------------"
echo "##### Way-3: Ask Yes/No with default Y #####"
echo "--------------------------------------------"
## arg1: "Prompt String, e.g. Enter choice (Y/n) default=Y? "
## arg2: Default value, Y (default) or N
answer=y
function askYesNo3() {
    # Prompt and wait for 5 seconds as timeout to accept default value.
    #read -t 5 -n 1 -p "Enter choice (Y/n) default=Y? " answer
    #read -t 5 -n 1 -p "$1" answer
    read -n 1 -p "$1" answer
    # defaulti is "Yes/Y"
    [ -z "$answer" ] && answer="Yes"  # if 'yes' have to be default choice
    answer=`echo ${answer:0:1}| tr '[:upper:]' '[:lower:]'`
    if [ "$answer" == "y" ]; then
        echo "===> Yes (you enter $answer)"
    else
        echo "===> No (you enter $answer)"
    fi
}
askYesNo3 "Enter choice (Y/n) default=Y? "

echo "--------------------------------------------"
echo "##### Way-4: Ask Yes/No with default Y #####"
echo "--------------------------------------------"
## arg1: "Prompt String, e.g. Enter choice (Y/n) default=Y? "
## arg2: Default value, Y (default) or N
answer=y
function askYesNo() {
    DEFAULT_YES_NO="y"
    if [ $# -lt 2 ]; then
        echo "---- INFO ----: No default choice provided, use Yes/Y as default!"
    fi
    # Prompt and wait for 5 seconds as timeout to accept default value.
    #read -t 5 -n 1 -p "Enter choice (Y/n) default=Y? " answer
    defaultValue=${2:-${DEFAULT_YES_NO}}
    defaultValue=`echo ${defaultValue:0:1}| tr '[:upper:]' '[:lower:]'`
    if [[ ! "nNyY" =~ "${defaultValue}" ]]; then
        defaultValue="${DEFAULT_YES_NO}"
    fi
    #read -t 5 -n 1 -p "$1" answer
    read -n 1 -p "$1" answer
    [ -z "$answer" ] && answer="$defaultValue" 
    answer=`echo ${answer:0:1}| tr '[:upper:]' '[:lower:]'`
    case ${answer:0:1} in
        y|Y )
            echo "===> Yes (you choice $answer)"
        ;;
        n|N )
            echo "===> No (you choice $answer)"
        ;;
        * ) 
            echo "===> Yes (you choice $defaultValue)"
            answer=$defaultValue
        ;;
    esac
}
askYesNo "Test-4-1: Continue (N/y) default=No/N? " 
askYesNo "Test-4-2: Continue (N/y) default=No/N? " "N"
askYesNo "Test-4-3: Continue (N/y) default=No/N? " "n"
askYesNo "Test-4-4: Continue (N/y) default=Yes/Y? " "Y"


