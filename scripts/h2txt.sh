#!/usr/bin/env bash

fpath="./srcprep/capi.txt"
i=0

echo "    C API:" > $fpath

while IFS='' read -r lineraw; do
    line=$(echo $lineraw | sed -E 's/^[[:space:]]*//')
    case $line in
        "extern"*";"*)
            echo "        o $(echo $line | sed -E 's/extern //g;s/ADD_IMPORT //g;s/;//g')" >> $fpath
            ;;
        *)
            ;;
    esac
done < $1
