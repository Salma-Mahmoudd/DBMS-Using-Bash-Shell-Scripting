#!/bin/bash

source ./scripts/drop_database.sh
source ./interface/get_database_name.sh

# handle_drop_database: A function to handle dropping of a database after user confirmation.
#
# $1: (Optional) Database name. If not provided, prompts the user to select a database.
#
# Returns: Prompts user for confirmation, deletes the database if confirmed, 
# or displays errors if the database does not exist.
#
# Usage: handle_drop_database "optional_database_name"

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