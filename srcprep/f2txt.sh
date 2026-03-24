#!/usr/bin/env bash

fpath=$2
i=0
func=0
offset=0
n=12

echo "    Fortran API:" > $fpath

while IFS='' read -r lineraw; do
    line=$(echo $lineraw | sed -E 's/^[[:space:]]*//')
    case $line in
        "function"*"("*")"*)
            func=1
            echo  -n "        o $line" >> $fpath
            offset=$((${#line} + $n))
            ;;
        "subroutine"*"("*")"*)
            func=1
            echo  -n "        o $line" >> $fpath
            ;;
        "end function"*)
            func=0
            ;;
        "end subroutine"*)
            func=0
            ;;
        "!! "*)
            if [[ $func == 1 ]]; then
                l=$(echo $line | sed -E 's/!! //g')
                echo     "  $l" >> $fpath
            fi
            if [[ $func > 1 ]]; then
                l=$(echo $line | sed -E 's/!! //g')
                printf %$(($offset +0))s " " >> $fpath
                echo $l >> $fpath
            fi
            func=$(($func + 1))
            ;;
        *"::"*"!!"*)
            if [[ $func > 0 ]]; then
                echo    "             o $(echo $line | sed -E 's/!/ /g')" >> $fpath
            fi
            ;;
        *)
            ;;
    esac
done < $1
