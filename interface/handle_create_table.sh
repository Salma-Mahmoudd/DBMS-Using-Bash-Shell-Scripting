#!/bin/bash

source ./scripts/create_table.sh
source ./interface/capture_table_data.sh

# handle_create_table: A function to capture table details from the user
# and create the table in the specified database.
#
# $1: Database name.
#
# Returns: Success or error message based on the table creation outcome.
#
# Usage: handle_create_table "database_name"

function handle_create_table(){
    local table_data
    typeset -i op

    table_data=$(capture_table_data "$1")
    op="$?"
    if [ $op -eq 0 ]; then
        create_table "$1" $table_data
        if [[ $op -eq 0 ]]; then
            zenity --width=300 --info --text="Table created successfully."
        else
            zenity --width=300 --error --text="Error occured while creating the file";
        fi
    fi
}