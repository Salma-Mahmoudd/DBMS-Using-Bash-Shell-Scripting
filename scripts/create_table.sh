#!/bin/bash

# create_table: Creates a new table in the specified database.
#
# This function creates a table within the specified database.
# It updates the metadata of the database and creates a new file to store table data.
#
# $1: The name of the database.
# $2: The name of the table.
# $3: Column definitions.
#
# Example:
#   create_table "my_database" "my_table" "column1 datatype column2 datatype"
#
# Returns:
#   None.

function create_table() { 
    echo "$2$3" >> "./databases/$1/metadata"
    touch "./databases/$1/$2"    
}