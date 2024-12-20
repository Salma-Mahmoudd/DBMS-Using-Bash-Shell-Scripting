#!/bin/bash

# drop_table: Removes a table from the specified database.
#
# This function deletes a table file and its entry from the database's metadata file.
#
# $1: The name of the database.
# $2: The name of the table to be dropped.
#
# Example:
#   drop_table "my_database" "my_table"
#
# Returns:
#   0 - Success.
#   1 - No table name provided.
#   2 - Table does not exist.

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