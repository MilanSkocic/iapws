#!/usr/bin/env bash

i=0

while IFS='' read -r lineraw; do
    line=$(echo $lineraw | sed -E 's/^[[:space:]]*//')
    case $line in
        *"function"*"("*")"*)
            echo  -n "        o $line"
            ;;
        *"subroutine"*"("*")"*)
            echo  -n "        o $line"
            ;;
        "!! "*)
            echo     "  $(echo $line | sed -E 's/!! //g')"
            ;;
        *"::"*"!!"*)
            echo    "             o $(echo $line | sed -E 's/!/ /g')"
            ;;
        *)
            ;;
    esac
done < $1
