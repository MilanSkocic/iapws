#!/usr/bin/env bash

fpath=$2
i=0

echo "    Python API:" > $fpath

while IFS='' read -r lineraw; do
    line=$(echo $lineraw | sed -E 's/^[[:space:]]*//')
    case $line in
        "def"*":"*)
            if [[ $line != "def _"* ]] && [[ $line != "def main"* ]]; then
                echo "        o $(echo $line | sed -E 's/def //g;;s/:*$//g')" >> $fpath
            fi
            ;;
        *)
            ;;
    esac
done < $1
