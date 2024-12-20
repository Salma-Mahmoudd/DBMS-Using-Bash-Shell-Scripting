#!/bin/bash

# create_database: Creates a new database.
#
# This function creates a new database with the specified name if it doesn't already exist.
# It checks for the validity of the database name and returns appropriate status codes.
#
# $1: The name of the database.
#
# Returns:
#   0 - Successfully created the database.
#   1 - Missing database name.
#   2 - Database already exists.
#   3 - Invalid database name.

function create_database() {
    local success=0

    if [[ -z "$1" ]]; then
        success=1
    elif [[ -d "./databases/$1" ]]; then
        success=2
    elif [[ ! "$1" =~ ^[a-zA-Z0-9._]+$ ]]; then
        success=3
    else
        mkdir -p "./databases/$1" && touch "./databases/$1/metadata"
    fi

    return $success
}
