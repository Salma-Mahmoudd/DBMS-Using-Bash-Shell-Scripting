#!/bin/bash

# drop_database: Deletes a database directory if it exists.
#
# This function removes the specified database directory and its contents.
# If the database doesn't exist, it returns an error.
#
# $1: The name of the database to be dropped.
#
# Example:
#   drop_database "my_database"
#
# Returns:
#   0 - Success.
#   1 - No database name provided.
#   2 - Database does not exist.

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