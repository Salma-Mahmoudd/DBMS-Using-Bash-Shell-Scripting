#!/bin/bash

# check_database_existence: Checks if a database exists.
#
# This function verifies whether the specified database exists in the "databases" directory.
#
# $1: The name of the database to check.
#
# Returns:
#   0 - If the database exists.
#   1 - If the database does not exist.

check_database_existance(){
    local res=1

    if [  -d "databases/$1" ]; then
        res=0
    fi

    return $res
}