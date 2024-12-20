#!/bin/bash

source ./interface/handle_create_database.sh
source ./interface/handle_list_databases.sh
source ./interface/handle_connect_to_database.sh
source ./interface/handle_drop_database.sh

# main.sh: A script to manage databases interactively.
#
# This script provides a graphical interface to perform database operations, including creating, listing, connecting to, and dropping databases.
#
# Parameters:
#   None
#
# Returns:
#   Runs until the user cancels or exits the script.
#
# Example:
#   source main.sh
#   Output: Prompts the user to perform various database operations through a menu.

open=1

while [ $open -eq 1 ]; do
	choice=$(zenity --width=500 --height=300 --list \
		--title="Welcome to Your Databases Manager" \
		--text="Please select one of the options below:" \
		--column="Options:" \
		"Create a database" \
		"List your databases" \
		"Connect to a database" \
		"Drop a database")

	if [ $? -ne 0 ]; then
		zenity --width=300 --info --text="Operation canceled."
		open=0
	elif [ "$choice" =  "Create a database" ]; then
		handle_create_database
	elif [ "$choice" = "List your databases" ]; then
		handle_list_databases
	elif [ "$choice" = "Connect to a database" ]; then
		handle_connect_to_database
	elif [ "$choice" = "Drop a database" ]; then
		handle_drop_database
	fi
done