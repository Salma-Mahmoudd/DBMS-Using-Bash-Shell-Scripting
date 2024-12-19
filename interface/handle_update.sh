#!/bin/bash
source ./scripts/get_table_columns.sh
source ./scripts/update_table.sh

function handle_update(){
    typeset -i i=1
	local update_field=""
	local columns=""
	local condition=""
    local text="Enter your update:"



    columns=$(get_table_columns $1 $2)

    while (( i < 2 ))
	do
		condition=$(zenity --width=400 --height=200 --forms \
   		--title="Update field from $2" \
		--text=$text \
   		--add-combo="Data type" --combo-values="$columns" \
    	--add-entry="Value" \
    	--separator=":")

		column=`echo $condition | cut -d: -f1`
		if [ -z $condition ]; then
    		zenity --width=300 --info --text="Operation canceled."
	    	return
		elif [ -z $column ]; then
			zenity --width=300 --error --text="Error: Enter the column name";
		else
			((i++))
			title="Enter your condition:"
		fi
	done

}