#!/bin/bash

# drop_table: remove table from the database
# $1: table name
#
# Return: 0 if success, 1 if argument does not exist, 2 if table does not exist

function drop_table() {
    local success=0

    if [[ -z "$1" ]]; then
        success=1
    elif [[ ! -f "$1" ]]; then
        success=2
    else
        rm "$1"
    fi

    return $success
}