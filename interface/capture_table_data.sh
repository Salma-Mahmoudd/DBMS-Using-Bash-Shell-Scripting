#!/bin/bash

source ./scripts/check_table_existance.sh

function capture_table_data(){
	local result table_name db_name title column 
	typeset -i num_columns open i op

	db_name="$1"
	open=1
	while (( open ))
	do
    	result=$(zenity --width=400 --height=200 --forms \
			--title="Create Table" \
			--text="Enter the table name and number of columns:" \
			--add-entry="Table Name" \
			--add-entry="Number of Columns")

		IFS='|' read -r table_name num_columns <<< "$result"
		if [[ -z $result ]]; then
			zenity --width=300 --info --text="Operation canceled."
			return 1
		elif [[ -z $table_name ]]; then
			zenity --width=300 --error --text="Error: Table name is missing!";
		elif [[ ! $table_name =~ ^[a-zA-Z0-9_.]+$ ]]; then
			zenity --width=400 --error --text="Error: File name must contain only letters (a-z, A-Z), numbers (0-9), underscores (_) or dots (.)."
		elif [[ $num_columns -lt 1 ]]; then
			zenity --width=300 --error --text="Error: Number of columns must be at least 1";	
		else
			check_table_existance "$db_name" "$table_name"
			op="$?"
			if [ $op -ne 0 ]; then
				open=0
			else
				zenity --width=300 --error --text="Error: Table already exists";
			fi	
		fi
	done

	i=0
	title="Please enter the primary key: "
	while (( i < num_columns ))
	do
    	column=$(zenity  --forms \
			--title="Add column $((i + 1))" \
			--text="$title" \
			--add-entry="Column name" \
			--add-combo="Data type" --combo-values="string|int|float" \
			--separator=":" \ )

		if [ -z "$column" ]; then
			zenity --width=300 --info --text="Operation canceled."
			return 1
		elif [[ ! $column =~ ^.+:.+$ ]]; then
			zenity --width=300 --error --text="Error: Column name or datatype is missing!";
		elif [[ ! $column =~ ^[a-zA-Z0-9_]+:.+$ ]]; then
			zenity --width=300 --error --text="Error: The name must contain only letters (a-z, A-Z), numbers (0-9), underscores (_)";
		elif [[ $table_data =~ ";"$column ]]; then
			zenity --width=300 --error --text="Error: You already entered this column";
		else
			table_data=$table_data";"$column
			((i++))
			title=""
		fi
	done

	echo "$table_name" "$table_data"
}