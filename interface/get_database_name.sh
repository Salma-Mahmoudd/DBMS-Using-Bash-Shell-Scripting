#!/bin/bash

# get_database_name: Function to prompt the user to enter the database name using Zenity.
#
# Returns: The database name entered by the user.
#
# Usage: db_name=$(get_database_name)

function get_database_name(){
	local db_name

	db_name=$(zenity --width=400 --height=150 --entry \
		--title="Database" \
		--text="Enter the database name:")

	echo "$db_name"
}