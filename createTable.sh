#!/bin/bash

# create table script
# input tableName arrayofcolumns
# 1-> missing arguments
# 2-> table exists
# 3-> invalid format or datatype

shopt -s nocasematch

typeset -i res=0
if [ $# -lt 2 ]
then
    res=1
else
    if [ -f $1 ]
    then
        res=2
    else
        file=$1
        str=$1
        shift
        while [ $# -ne 0  ]
        do
            if [[  $1 =~ ^[a-z0-9_]+:(string|int)$ ]]
            then
                str="$str;$1"
                shift
            else
                res=3
                break
            fi
        done
        if [ $res -eq 0 ]
        then
            echo $str >> metaData
            touch $file
        fi
    fi
fi
shopt -u nocasematch
exit $res
