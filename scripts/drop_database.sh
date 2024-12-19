#!/bin/bash

# drop databses
# input database name
# 1-> missing arguments
# 2-> databse doesn't exist

function drop_database(){
    local res=0

    if [ $# -eq 0 ]
    then
        res=1
    else
        if [ -d "./databases/$1" ]
            then
                rm -r "./databases/$1"
        else
                res=2
        fi
    fi

    return $res
}