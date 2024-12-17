#!/bin/bash

# list_tables: to show user tables in specific database
#
# Return: list if success, 1 if No tables found.

function list_tables() {
    local success=1

    if [ -d "./databases/$1" ]; then
        ls -A "./databases/$1/"
        success=0
    fi

    return "$success"
}