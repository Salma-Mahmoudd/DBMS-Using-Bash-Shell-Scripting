#!/bin/bash
source ./scripts/create_database.sh
source ./scripts/list_databases.sh
source ./scripts/drop_database.sh

function selected_database(){
	choice=$(zenity --width=500 --height=300 --list \
		--title="$1 database" \
		--text="Please select one of the options below:" \
		--column="Options:" \
		"Create a table" \
		"List your tables" \
		"Insert into a table" \
		"Select from a table" \
		"Delete from a table" \
		"Drop a table")

	echo "$choice"
}

function db_name(){
	db_name=$(zenity --width=400 --height=150 --entry \
		--title="Create Database" \
		--text="Enter the database name:")

	echo "$db_name"
}

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
		db_name=$(db_name)

		create_database "$db_name"
		case $? in
			0) zenity --width=300 --info --text="Database created successfully!";;
			1) zenity --width=300 --error --text="Error: Database name is missing!";;
			2) zenity --width=300 --error --text="Error: Database already exists!";;
			3) zenity --width=400 --error --text="Error: The name must contain only letters (a-z, A-Z), numbers (0-9), underscores (_) or dots (.).";;
			*) zenity --width=300 --error --text="An unknown error occurred!";;
		esac
	elif [ "$choice" = "List your databases" ]; then
		databases=$(list_databases)

		if [ $? -eq 1 ]; then
			zenity --width=300 --info --text="No databases found."
		else
			choice=$(zenity --width=500 --height=300 --list \
				--title="Your Databases" \
				--text="Select one of the databases to connect:" \
				--column="Database:" \
				$databases)

			if [ -n "$choice" ]; then
				choice2=$(zenity --width=500 --height=300 --list \
					--title="$choice database" \
					--text="Do you want to connect or drop $choice database?" \
					--column="Options:" \
					"Connect to $choice" \
					"Drop $choice")

				if [ "$choice2" = "Connect to $choice" ]; then
					selected_database "$choice"
				elif [ "$choice2" = "Drop $choice" ]; then
					zenity --width=300 --question --text="Are you sure you want to drop this database?"
					if [ $? -eq 0 ]; then
                        drop_database "$choice"
                    fi
				fi
			else
    			zenity --width=300 --info --text="No database selected."
			fi
		fi
	elif [ "$choice" = "Connect to a database" ]; then
		db_name=$(db_name)
		selected_database "$db_name"
	elif [ "$choice" = "Drop a database" ]; then
		db_name=$(db_name)
		if [ -n "$db_name" ]; then
			zenity --width=300 --question --text="Are you sure you want to drop this database?"
			if [ $? -eq 0 ]; then
				drop_database "$db_name"
				if [ $? -eq 0 ]; then
				    zenity --width=300 --info --text="Database dropped successfully!";
                else
				    zenity --width=300 --error --text="Error: Database does not exist.";
                fi
			fi
		fi
	fi
done