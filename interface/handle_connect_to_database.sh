#!/bin/bash

source ./interface/get_database_name.sh
source ./interface/handle_create_table.sh
source ./interface/handle_list_tables.sh

function handle_connect_to_database(){
    local db_name choice
    typeset -i open

    if [[ -z "$1" ]]; then
        db_name=$(get_database_name)
    else
        db_name="$1"
    fi
    open=1
    while [ $open -eq 1 ]; do
        if [[ $db_name == "" ]]; then
            open=0
            zenity --width=300 --error --text="Database name is missing!"
        elif [[ -d "./databases/$db_name" ]]; then
                choice=$(zenity --width=500 --height=300 --list \
                    --title="$db_name database" \
                    --text="Please select one of the options below:" \
                    --column="Options:" \
                    "Create a table" \
                    "List your tables")

                if [[ $choice == "" ]]; then
                    open=0
                elif [ "$choice" =  "Create a table" ]; then
                    handle_create_table "$db_name"
                elif [ "$choice" =  "List your tables" ]; then
                    handle_list_tables "$db_name"
                fi
        else
            zenity --width=300 --error --text="This database doesn't exist"
            db_name=$(get_database_name)
        fi
    done
}