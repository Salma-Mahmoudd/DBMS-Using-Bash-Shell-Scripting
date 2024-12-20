#!/bin/bash
source ./scripts/get_table_columns.sh
source ./scripts/select_from_table.sh

# handle_select: A function to interactively select
# data from a table with optional conditions.
#
# This script allows users to select specific columns
# from a table and optionally filter the results based on a condition.
#
# $1: The database name.
# $2: The table name.
#
# Returns: Prompts the user to select columns and apply conditions for the selection process.
#
# Usage: handle_select "database_name" "table_name"

function handle_select(){
	local choice=""
	local columns=""
	local options=""
	local condition=":"
	local column
	local -a headers values

	columns=$(get_table_columns $1 $2)
	for column in $columns; do
    	options="$options TRUE $column"
	done
	choices=$(zenity --list --checklist \
    --width=500 --height=400 \
    --title="Select columns" \
    --column="Select" --column="Option" \
	--separator=" " \
	$options
    )

	if [ $? -eq 0 ]; then
		zenity --width=300 --question --text="Do you have a condition on the select process?"
		if [ $? -eq 0 ]; then	
			while true
			do
				condition=$(zenity --width=400 --height=200 --forms \
   				--title="Select from $2" \
    			--text="Enter your condition:" \
   				--add-combo="column" --combo-values="$(echo ${columns[@]} | tr " " "|")" \
    			--add-entry="Value" \
    			--separator=":")

				column=`echo $condition | cut -d: -f1`
				if [ -z $condition ]; then
					zenity --width=300 --info --text="Operation canceled."
					return
				elif [ -z $column ]; then
					zenity --width=300 --error --text="Error: Enter the column name";
				else
					break
				fi
			done
		fi
		rows="$(select_from_table $1 $2 $condition ${choices[@]})"
    	for column in $choices; do
        	headers+=("--column=$column")
    	done
    	read -r -a values <<< "$rows"
		zenity --list "${headers[@]}" "${values[@]}"
	fi

}