#!/bin/bash

# get_table_datatypes: Retrieves the data types of columns from the table's metadata.
#
# This function extracts and returns the data types of the columns from the table's metadata.
#
# $1: The name of the database.
# $2: The name of the table.
#
# Returns:
#   The data types of the columns, separated by spaces.
#
# Example:
#   get_table_datatypes "my_database" "my_table"

function get_table_datatypes() {
    local columns

    columns=$(grep "^$2;" "./databases/$1/metadata" \
        | awk -F";" '{ for (i=2; i<=NF; i++) print $i }' \
        | cut -d: -f2)

    echo $columns
}