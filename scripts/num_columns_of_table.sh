#!/bin/bash

# num_columns_of_table: Determine the number of columns in a specified table from a database.
#
# This function reads metadata from the database's metadata file to count the columns of a given table.
# It searches for the table name in the metadata file, calculates the number of columns by counting 
# fields delimited by semicolons, and returns the column count.
#
# Parameters:
#   $1 - The name of the database.
#   $2 - The name of the table.
#
# Returns:
#   The number of columns in the specified table.
#
# Example:
#   num_columns=$(num_columns_of_table "your_database_name" "your_table_name")
#   Output: The number of columns in the "your_table_name" table.  

function num_columns_of_table(){
    typeset -i num_columns
    local meta_path

    meta_path="./databases/$1/metadata"
    num_columns=$(awk -F';' -v table_name="$2" \
        '{if ($1 == table_name) print NF - 1}' \
        "$meta_path")

    return "$num_columns"
}