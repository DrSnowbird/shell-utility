#!/bin/bash 

#jq '.' myLargeUnformattedFile.json > myLargeBeautifiedFile.json

if [ $# -lt 1 ]; then
    echo ">>> Usage: "
    echo "  $0 <unformated_json> [<formated_output_json>]"
    echo "  "
    echo "  (if you don't provide <formated_output_json> argument,"
    echo "   then, it will print to the console!)"
    exit 1
fi
IN_JSON=${1}
OUT_JSON=${2}
if [ "$OUT_JSON" != "" ]; then
    cat ${IN_JSON} | python3 -m json.tool > ${OUT_JSON}
else
    cat ${IN_JSON} | python3 -m json.tool 
fi
