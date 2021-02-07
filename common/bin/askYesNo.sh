#!/bin/bash

CONT_YES=1
function askToContinue() {
    read -p "Are you sure to continue (Yes/No)?" -n 1 -r
    echo    # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo ".... do dangerous stuff"
    else
        CONT_YES=0
        exit 0
    fi
}
echo $CONT_YES
askToContinue
