#!/bin/bash

source ./scripts/list_databases.sh
source ./interface/handle_connect_to_database.sh
source ./interface/handle_drop_database.sh

# handle_list_databases: A function to list databases and provide options to connect or drop.
#
# This script lists available databases and allows the user to select one,
# either to connect or drop.
#
# $1: No arguments required.
#
# Returns: Prompts the user to select a database,
# then provides options to either connect to it or drop it.
#
# Usage: handle_list_databases

function handle_list_databases(){
    local databases choice choice2
    typeset -i open op

    open=1
    while (( open )); do
        databases=$(list_databases)
        op="$?"
        if [ $op -eq 2 ]; then
            zenity --width=300 --info --text="No databases found."
            open=0
        else
            choice=$(zenity --width=500 --height=300 --list \
                --title="Databases" \
                --text="Select one of your databases" \
                --column="Databases:" \
                $databases)

            if [ -n "$choice" ]; then
                choice2=$(zenity --width=500 --height=300 --list \
                    --title="$choice database" \
                    --text="Do you want to connect or drop $choice database?" \
                    --column="Options:" \
                    "Connect to $choice" \
                    "Drop $choice")

                if [ "$choice2" = "Connect to $choice" ]; then
                    handle_connect_to_database "$choice"
                elif [ "$choice2" = "Drop $choice" ]; then
                    handle_drop_database "$choice"
                fi
            else
                open=0
            fi
        fi
    done
}