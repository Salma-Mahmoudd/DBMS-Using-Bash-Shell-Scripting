#!/bin/bash

source ./scripts/list_tables.sh
source ./interface/handle_drop_table.sh
source ./interface/handle_insert_into_table.sh
source ./interface/handle_select_from_table.sh
source ./interface/handle_update.sh

function handle_list_tables(){
    local db_name tables
    typeset -i open1 open2 op

    db_name="$1"
    open1=1
    while (( open1 )); do
        tables=$(list_tables "$db_name")
        op="$?"
        if [[ $op -ne 0 ]]; then
            zenity --width=300 --info --text="No tables found"
            open1=0
        else
            choiced_table=$(zenity --list \
            --title="Database: $db_name" \
            --column="Tables" \
            $tables)

            op="$?"
            if [[ $op -ne 0 ]]; then
                open1=0
            elif [ -n "$choiced_table" ]; then
                open2=1
                while (( open2 )); do
                    choice2=$(zenity --width=500 --height=300 --list \
                        --title="$choiced_table table in $db_name database" \
                        --text="Please select one of the options below:" \
                        --column="Options:" \
                        "Show the entire table data" \
                        "Insert data into the table" \
                        "Select data from the table" \
                        "Delete data from the table" \
                        "Update the table data" \
                        "Drop the table")

                    op="$?"
                    if [[ $op -ne 0 ]]; then
                        open2=0
                    elif [ "$choice2" = "Insert data into the table" ]; then
                        handle_insert_into_table "$db_name" "$choiced_table"
                    elif [ "$choice2" = "Drop the table" ]; then
                        handle_drop_table "$db_name" "$choiced_table"
                        open2=0
                    elif [ "$choice2" = "Select data from the table" ]; then
                        handle_select "$db_name" "$choiced_table"
                    elif [ "$choice2" = "Update the table data" ]; then
                        handle_update "$db_name" "$choiced_table"
                    fi

                done
            fi
        fi
    done
}