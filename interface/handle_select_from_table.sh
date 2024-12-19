#!/bin/bash
source ./scripts/get_table_columns.sh
source ./scripts/select_from_table.sh

function handle_select(){
	local choice=""
	local columns=""
	local options=""
	local condition=":"
	local column

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
   				--add-entry="Column Name" \
    			--add-entry="Value" \
    			--separator=":")

				column=`echo $condition | cut -d: -f1`
				if [ -z $condition ]; then
					zenity --width=300 --info --text="Operation canceled."
					return
				elif [ $(echo "$columns" | grep -wc "$column" ) -eq 0 ]; then
					zenity --width=300 --error --text="Error: Column does not exist";
				else
					break
				fi
			done
		fi
		rows=$(select_from_table $1 $2 $condition ${choices[@]})
		original_ifs=$IFS
		IFS=$'\n' read -d '' -r -a row_array <<< "$rows"
		IFS=$original_ifs
		zenity --list \
        	--title="rows: $1" \
        	--column="Tables" \
        "${row_array[@]}"

	fi

}