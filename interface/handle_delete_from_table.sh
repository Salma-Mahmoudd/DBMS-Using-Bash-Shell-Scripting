#!/bin/bash

source ./scripts/get_table_columns.sh
source ./scripts/num_columns_of_table.sh
source ./scripts/delete_from_table.sh

# handle_delete_from_table: A function to handle deletion of records from a table
# based on user-selected conditions.
#
# $1: Database name.
# $2: Table name.
#
# Returns: Prompts the user to select columns and enter values
# for deletion conditions, then deletes matching records from the table.
#
# Usage: handle_delete_from_table "database_name" "table_name"

function handle_delete_from_table(){
    typeset -i num_columns
    local list columns_name col_name col_val db_name=$1 table_name=$2
    local -a list

    num_columns_of_table "$1" "$2"
    num_columns="$?"
    read -r -a columns_name <<< "$(get_table_columns "$db_name" "$table_name")"
    list+=(true "${columns_name[0]}")

    for (( i = 1; i < num_columns; i++ )); do
        list+=(false "${columns_name[$i]}")
    done

    col_name=$(zenity --list --width=500 --height=300 \
        --title="Condition to delete data" \
        --text="Select a column from your table" \
        --column="Check" --column="Column name" \
        "${list[@]}" \
        --radiolist)

    col_val=$(zenity --entry --width=500 --height=150 \
        --title="Condition to delete data" \
        --text="Enter value of $col_name column")

    delete_from_table "$db_name" "$table_name" "$col_name" "$col_val"
}