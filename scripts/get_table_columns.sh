#!/bin/bash

# get_table_columns: Retrieves the column names of a table from the database.
#
# This function extracts and returns the column names from the metadata of a table.
#
# $1: The name of the database.
# $2: The name of the table.
#
# Returns:
#   The column names, separated by spaces.
#
# Example:
#   get_table_columns "my_database" "my_table"

function get_table_columns() {
    local columns

    columns=$(grep "^$2;" "./databases/$1/metadata" \
        | awk -F";" '{ for (i=2; i<=NF; i++) print $i }' \
        | cut -d: -f1)

    echo $columns
}