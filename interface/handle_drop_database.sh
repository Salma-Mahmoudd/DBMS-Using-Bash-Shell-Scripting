#!/bin/bash

source ./scripts/drop_database.sh
source ./interface/get_database_name.sh

function handle_drop_database(){
    local db_name
    typeset -i op

    if [[ -z "$1" ]]; then
        db_name=$(get_database_name)
    else
        db_name="$1"
    fi
    if [[ $db_name == "" ]]; then
        zenity --width=300 --info --text="Error: Nothing to drop.";
    elif [[ -n "$db_name" ]]; then
        if [[ -d "./databases/$db_name" ]]; then
            zenity --width=300 --question --text="Are you sure you want to drop this database?"
            op="$?"
            if [ $op -eq 0 ]; then
                drop_database "$db_name"
                zenity --width=300 --info --text="Database dropped successfully!";
            fi
        else
            zenity --width=300 --error --text="Error: Database does not exist.";
        fi
    fi
}