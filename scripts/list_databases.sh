#!/bin/bash

# list_databases: to show user databases
#
# Return: list if success, 1 if No databases found.

function list_databases() {
    local success=1

    if [ -d "databases" ]; then
        ls -A ./databases
        success=0
    fi

    return "$success"
}