#!/bin/bash

# create_table: create table in specific database and its metadata. First column must be a primary key
# $1: table name
# $2 $3...: column names and their types (e.g., column1 primary:string, column2:int)
#
# Return: 0 if success, 1 if arguments do not exist, 2 if table exists,
# 3 if invalid syntax and 4 if there is no primary key


function create_table() {
    shopt -s nocasematch

    typeset -i res=0
    typeset -i pk=1
    str=""
    str2=""
    
    if [ $# -lt 2 ]
    then
        res=1
    else
        if [ -f "$1" ]
        then
            res=2
        else
            file=$1
            str=$1
            shift
            while [ $# -ne 0  ]
            do
                if [[ $1 =~ ^[a-z0-9_]+:(string|int)$ ]]
                then
                    str2="$str2;$1"
                    shift
                elif [[ $1 =~ ^[a-z0-9_]+[[:space:]]primary:(string|int)$ && $pk == 1 ]]
                then
                    pk=0
                    str="$str;$(echo "$1" | sed -E 's/^([a-z0-9_]+) primary:(string|int)$/\1:\2/')"
                    shift
                else
                    res=3
                    break
                fi
            done
            if [[ $pk -ne 0 && $res -eq 0 ]]
            then
                res=4
            elif [ $res -eq 0 ]
            then
                str="$str$str2"
                echo "$str" >> metadata
                touch "$file"
            fi
        fi
    fi
    shopt -u nocasematch

    return $res
}