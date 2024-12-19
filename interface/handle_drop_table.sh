#!/bin/bash

source ./interface/get_table_name.sh
source ./scripts/drop_table.sh

function handle_drop_table(){
    local db_name table_name
    typeset -i op

    db_name="$1"
    if [[ -z "$2" ]]; then
        table_name=$(get_table_name)
    else
        table_name="$2"
    fi
    if [ -n "$table_name" ]; then
        zenity --width=300 --question --text="Are you sure you want to drop this table?"
        op="$?"
        if [ $op -eq 0 ]; then
            drop_table "$db_name" "$table_name"
            case $? in
                0) zenity --width=300 --info --text="Table deleted successfully!";;
                1) zenity --width=300 --error --text="Error: Table name is missing!";;
                2) zenity --width=300 --error --text="Error: Table doesn't exist!";;
                *) zenity --width=300 --error --text="An unknown error occurred!";;
            esac
        fi
    fi
}