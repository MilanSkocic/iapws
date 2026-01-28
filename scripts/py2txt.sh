#!/usr/bin/env bash

i=0

while IFS='' read -r lineraw; do
    line=$(echo $lineraw | sed -E 's/^[[:space:]]*//')
    case $line in
        "def"*":"*)
            echo "        o $(echo $line | sed -E 's/def //g;;s/:*$//g')"
            ;;
        *)
            ;;
    esac
done < $1
