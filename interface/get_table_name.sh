#!/bin/bash

# get_table_name: Function to prompt the user to enter the table name using Zenity.
#
# Returns: The table name entered by the user.
#
# Usage: table_name=$(get_table_name)

function get_table_name(){
	local table_name

	table_name=$(zenity --width=400 --height=150 --entry \
		--title="Table" \
		--text="Enter the table name:")

	echo "$table_name"
}