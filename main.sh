#!/bin/bash
source ./scripts/create_database.sh
source ./scripts/list_databases.sh
source ./scripts/drop_database.sh
source ./scripts/create_table.sh
source  ./scripts/check_table_existance.sh
source  ./scripts/check_database_existance.sh
source ./scripts/list_tables.sh
source ./scripts/drop_table.sh

function capture_table_data(){
	
	typeset -i num_columns

	open=1
	while (( open ))
	do
    	result=$(zenity --width=400 --height=200 --forms \
    	--title="Create Table" \
    	--text="Enter the table name and number of columns:" \
    	--add-entry="Table Name" \
    	--add-entry="Number of Columns")
		original_ifs=$IFS
		IFS='|' read -r table_name num_columns <<< "$result"
		IFS=$original_ifs
		if [ -z $result ]; then
			zenity --width=300 --info --text="Operation canceled."
			return 1
		elif [ -z $table_name ]; then
			zenity --width=300 --error --text="Error: Table name is missing!";
		elif [[ ! $table_name =~ ^[a-z0-9_.]+$ ]]; then
			zenity --width=400 --error --text="Error: File name must contain only letters (a-z, A-Z), numbers (0-9), underscores (_) or dots (.)."
		elif [ $num_columns -lt 1 ]; then
			zenity --width=300 --error --text="Error: column number must be >= 1";	
		else
			check_table_existance $1 $table_name
			if [ $? -ne 0 ]; then
				open=0
			else
				zenity --width=300 --error --text="Error: Table already exists";
			fi	
		fi
	done
	typeset -i i=0
	while (( i < num_columns ))
	do
		if [[ i -eq 0 ]]; then
			title="Please enter the primary key: "
		fi
    	column=$(zenity  --forms \
        --title="Add column $((i + 1))" \
        --text="$title" \
        --add-entry="Column name" \
        --add-combo="Data type" --combo-values="string|int|float" \
		--separator=":" \ )
		if [ -z $column ]; then
			zenity --width=300 --info --text="Operation canceled."
			return 1
		elif [[ ! $column =~ ^.+:.+$ ]]; then
			zenity --width=300 --error --text="Error: Column name or datatype is missing!";
		elif [[ ! $column =~ ^[a-z0-9_]+:.+$ ]]; then
			zenity --width=300 --error --text="Error: The name must contain only letters (a-z, A-Z), numbers (0-9), underscores (_)";
		elif [[ $table_data =~ ";"$column ]]; then
			echo $column >> text
			echo $table_data >> text
			zenity --width=300 --error --text="Error: You already entered this column";
		else
			table_data=$table_data";"$column
			((i++))
			title=""
		fi
	done
	echo $table_name $table_data
}
# function select_table(){

# }
function selected_database(){
	local open=1

	while [ $open -eq 1 ]; do
	choice=$(zenity --width=500 --height=300 --list \
		--title="$1 database" \
		--text="Please select one of the options below:" \
		--column="Options:" \
		"Create a table" \
		"List your tables" \
		"Insert into a table" \
		"Select from a table" \
		"Delete from a table" \
		"Update table" \
		"Drop a table")
	if [ $? -ne 0 ]; then
		open=0
	elif [ "$choice" =  "Create a table" ]; then
		table_data=$(capture_table_data $1)
		if [ $? -eq 0 ]; then
			create_table $1 $table_data
			if [[ $? -eq 0 ]]; then
				zenity --width=300 --info --text="Table created successfully."
			else
				zenity --width=300 --error --text="Error occured while creating the file";
			fi
		fi
	elif [ "$choice" =  "List your tables" ]; then
		tables=$(list_tables $1)
		if [[ $? -ne 0 ]]; then
			zenity --width=300 --info --text="No tables found"
		else
			choiced_table=$(zenity --list \
        	--title="Database: $1" \
        	--column="Tables" \
        	$(echo "$tables"))
			echo $choiced_table > taxt
			if [ -n "$choiced_table" ]; then
				choice2=$(zenity --width=500 --height=300 --list \
						--title="$choiced_table table" \
						--text="Do you want to list or drop $choiced_table table?" \
						--column="Options:" \
						"list $choiced_table" \
						"Drop $choiced_table")
				if [ "$choice2" = "list $choiced_table" ]; then
					echo hi
				elif [ "$choice2" = "Drop $choiced_table" ]; then
						zenity --width=300 --question --text="Are you sure you want to drop this table?"
						if [ $? -eq 0 ]; then
                        	drop_table $1 $choiced_table
                    	fi
				fi
			else
				zenity --width=300 --info --text="No selected table";
			fi
		fi
	elif [ "$choice" =  "Drop a table" ]; then
		table_name=$(zenity --width=400 --height=150 --entry \
		--title="Drop Table" \
		--text="Enter the table name:")
		zenity --width=300 --question --text="Are you sure you want to drop this database?"
		if [ $? -eq 0 ]; then
			drop_table $1 $table_name
			case $? in
				0) zenity --width=300 --info --text="Table deleted successfully!";;
				1) zenity --width=300 --error --text="Error: Table name is missing!";;
				2) zenity --width=300 --error --text="Error: Table doesn't exist!";;
				*) zenity --width=300 --error --text="An unknown error occurred!";;
			esac
		fi
	fi
	done
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
		check_database_existance $db_name
		if [ $? -eq 0 ]; then
			echo $open > text
			selected_database "$db_name"
			echo $open >> text
		else
			zenity --width=300 --error --text="Database doesn't exist"
		fi
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