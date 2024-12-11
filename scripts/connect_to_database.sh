#!/bin/bash

# connect to databses
# input database name
# 1-> missing arguments
# 2-> databse doesn't exist

typeset -i res=0

if [ $# -eq 0 ]
then
    res=1
else
    if [ -d $1 ]
    then
        cd $1
    else
        res=2
    fi
fi
exit $res
