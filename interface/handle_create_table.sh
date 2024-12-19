#!/bin/bash

source ./scripts/create_table.sh
source ./interface/capture_table_data.sh

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