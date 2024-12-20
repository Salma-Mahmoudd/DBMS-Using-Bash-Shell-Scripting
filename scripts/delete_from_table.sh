#!/bin/bash

source ./scripts/get_table_columns.sh

# delete_from_table: Deletes rows from a table based on specified field and value.
#
# This function removes rows from a table where the specified field name and value match.
# It reads through the table data, filters out the matching rows, and updates the table.
#
# $1: The name of the database.
# $2: The name of the table.
# $3: The field name to check.
# $4: The field value to match.
#
# Example:
#   delete_from_table "my_database" "my_table" "column_name" "value_to_delete"
#
# Returns:
#   None.

function delete_from_table(){
    typeset -i field_num i=1
    local field_name field_val table_path
    local -a columns_name

    read -r -a columns_name <<< "$(get_table_columns "$1" "$2")"
    table_path="./databases/$1/$2"
    field_name=$3
    field_val=$4

    for j in "${columns_name[@]}"; do
        if [[ "${j}" == "${field_name}" ]]; then
            field_num=$((i))
            break
        fi
        ((i++))
    done

    awk -F: -v f="$field_num" -v val="$field_val" \
        '$f != val {print $0}' \
        "$table_path" > temp && mv temp "$table_path"
}