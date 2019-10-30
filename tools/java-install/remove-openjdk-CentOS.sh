#!/bin/bash 

javaExcept=${1:-11}
echo
echo "........................................................"
echo "... Uninstall / remove all Java/Jre OpenJDK versions ..."
echo "........................................................"
echo
read -p "Are you sure you want to continue? <Y/N> " prompt
if [[ $prompt =~ [yY](es)* ]]; then
    javaList=`rpm -qa | grep "^java-" `
    jreList=`rpm -qa | grep "^jre-" `
    for j in "$javaList $jreList"; do
        if [[ "$j" =~ $javaExcept ]]; then
            echo "... Keep the version: $j since matching exception $javaExcept"
        else
            sudo yum remove -y $j
        fi
    done
fi
