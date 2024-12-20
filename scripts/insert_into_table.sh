#!/bin/bash

source ./scripts/num_columns_of_table.sh
source ./scripts/get_table_datatypes.sh

# insert_into_table: Inserts data into a table, with validation based on column data types.
#
# This function inserts data into a specified table
# after validating the values against their column data types.
#
# $1: The name of the database.
# $2: The name of the table.
# $3: The values to be inserted in the format
# "col1_val:col2_val:..." where colN_val corresponds to column N.
#
# Returns:
#   0 - Success (Data inserted)
#   1 - Error (Primary key not provided)
#   2 - Error (Primary key already exists)
#   3 - Error (Data type mismatch)
#
# Example:
#   insert_into_table "my_database" "my_table" "123:John Doe:30"

function insert_into_table(){
    typeset -i err num_columns i
    local table_path pk val
    local -a column_values table_datatypes

    err=0
    num_columns_of_table "$1" "$2"
    num_columns="$?"
    table_path="./databases/$1/$2"
    read -r -a table_datatypes <<< "$(get_table_datatypes "$1" "$2")"
    shift 2
    column_values="$*"
    pk=$(echo "$column_values" | cut -d: -f1)

    if [[ -z $pk ]]; then
        err=1
    elif grep -qE "^$pk:" "$table_path"; then
        err=2
    else
        for (( i = 1; i <= num_columns && err==0; i++ )); do
            val=$(echo "$column_values" | cut -d: -f"$i")
            if [[ -n $val ]]; then
                case ${table_datatypes[$i - 1]} in
                    "int") if [[ ! $val =~ ^-?[0-9]+$ ]]; then err=3; fi;;
                    "float") if [[ ! $val =~ ^-?[0-9]+(.[0-9]+)?$ ]]; then err=3; fi;;
                    "string") if [[ $val =~ : ]]; then err=3; fi;;
                esac
            fi
        done
    fi
    if [[ $err == 0 ]]; then
        (echo "${column_values[*]}" >> "$table_path")
    fi

    return "$err"
}