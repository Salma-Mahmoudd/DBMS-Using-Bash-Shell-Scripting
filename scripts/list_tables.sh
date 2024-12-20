#!/bin/bash

# list_tables: Lists all tables within a specified database.
#
# This function checks if the provided database exists by verifying its directory.
# If the database exists, it lists all files (tables) in the directory,
# excluding the "metadata" file.
# If the database doesn't exist, it exits with an error.
#
# Parameters:
#   $1 - The name of the database to list tables from.
#
# Returns:
#   0 - Success (Tables listed).
#   1 - Error (Database directory not found or empty).
#
# Example:
#   list_tables "my_database"
#   Output: Lists table names in "my_database" if available.

function list_tables() {
    local success=1

    if [ -d "./databases/$1" ]; then
        ls -A "./databases/$1/" | grep -v "^metadata$"
        success=0
    fi

    return "$success"
}