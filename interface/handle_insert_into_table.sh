#!/bin/bash

source ./scripts/num_columns_of_table.sh
source ./scripts/get_table_columns.sh
source ./scripts/get_table_datatypes.sh
source ./scripts/insert_into_table.sh

# handle_insert_into_table: A function to insert data into
# a table after user input validation.
#
# $1: Database name.
# $2: Table name.
#
# Returns: Prompts user to enter values for each column,
# validates input, and inserts the row if valid.
#
# Usage: handle_insert_into_table "database_name" "table_name"

function handle_insert_into_table(){
    typeset -i num_columns open
    local row form_args i
    local -a columns_name columns_datatype

    num_columns_of_table "$1" "$2"
    num_columns="$?"

    if (( num_columns == 0 )); then
        zenity --width=300 --error --text="Error: This table does not exist"
    else
        open=1
        read -r -a columns_name <<< "$(get_table_columns "$1" "$2")"
        read -r -a columns_datatype <<< "$(get_table_datatypes "$1" "$2")"
        for (( i = 0; i < num_columns; i++ )); do
            form_args+=("--add-entry=${columns_name[$i]} (${columns_datatype[$i]})")
        done
        while (( open )); do
            row=$(zenity --forms --width=500 --height=300 \
                --title="Inset a new row in your table" \
                --text="Enter the column values (first is mandatory (primary key).)." \
                --separator=":" \
                "${form_args[@]}")
            if [[ $? -ne 0 ]]; then
                open=0
            else
                insert_into_table "$1" "$2" "$row"
                case $? in
                    0) zenity --width=300 --info --text="Row added successfully!"; open=0;;
                    1) zenity --width=300 --error --text="Error: Primary key is missing!";;
                    2) zenity --width=300 --error --text="Error: That primary key is not unique!";;
                    3) zenity --width=300 --error --text="Error: Format or datatype is wrong!";;
                esac
            fi
        done
    fi
}