#!/bin/bash

source ./scripts/create_database.sh
source ./interface/get_database_name.sh

function handle_create_database(){
    local db_name
    typeset -i open

    open=1
    while (( open )); do
        db_name=$(get_database_name)
        create_database "$db_name"
        case $? in
            0) zenity --width=300 --info --text="Database created successfully!"; open=0;;
            2) zenity --width=300 --error --text="Error: Database already exists!";;
            3) zenity --width=400 --error --text="Error: The name must contain only letters (a-z, A-Z), numbers (0-9), underscores (_) or dots (.).";;
            *) zenity --width=300 --info --text="Nothing to create!"; open=0;;
        esac
    done
}