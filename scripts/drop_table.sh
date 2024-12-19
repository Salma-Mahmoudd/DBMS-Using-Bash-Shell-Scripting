#!/bin/bash

# drop_table: remove table from the database
# $1: table name
#
# Return: 0 if success, 1 if argument does not exist, 2 if table does not exist

function drop_table() {
    local success=0

    if [[ -z "$2" ]]; then
        success=1
    elif [[ ! -f "./databases/$1/$2" ]]; then
        success=2
    else
        sed -i "/^$2;/d" ./databases/$1/metadata
        rm "./databases/$1/$2"
    fi

    return $success
}