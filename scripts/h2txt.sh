#!/usr/bin/env bash

i=0

while IFS='' read -r lineraw; do
    line=$(echo $lineraw | sed -E 's/^[[:space:]]*//')
    case $line in
        *"extern"*";"*)
            echo "        o $(echo $line | sed -E 's/extern //g;s/ADD_IMPORT //g;s/;//g')"
            ;;
        *)
            ;;
    esac
done < $1
