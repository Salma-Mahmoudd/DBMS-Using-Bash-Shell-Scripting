#!/bin/bash

# check_table_existence: Checks if a table exists in a specific database.
#
# This function verifies whether the specified table exists within a given database.
#
# $1: The name of the database.
# $2: The name of the table.
#
# Returns:
#   0 - If the table exists.
#   1 - If the table does not exist.

check_table_existance(){
    local res=1

    if [  -f "databases/$1/$2" ]; then
        res=0
    fi

    return $res
}