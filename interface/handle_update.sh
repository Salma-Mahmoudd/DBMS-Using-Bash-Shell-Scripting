#!/bin/bash
source ./scripts/get_table_columns.sh
source ./scripts/update_table.sh

function handle_update(){
    typeset -i i=0
	local update_field=""
	local columns=""
	local data[2]
    local text="Enter your condition:"



    read -a columns <<< "$(get_table_columns $1 $2)"

    while (( i < 2 ))
	do
		data[$i]=$(zenity --width=400 --height=200 --forms \
   		--title="Update field from $2" \
		--text="$text" \
   		--add-combo="column" --combo-values="$(echo ${columns[@]} | tr " " "|")" \
    	--add-entry="Value" \
    	--separator=":")

		column=`echo ${data[$i]} | cut -d: -f1`
		if [ -z "${data[$i]}" ]; then
    		zenity --width=300 --info --text="Operation canceled."
	    	return
		elif [ -z "$column" ]; then
			zenity --width=300 --error --text="Error: Enter the column name";
		else
			((i++))
            columns=(${columns[@]:1})
			text="Enter your update:"
		fi
	done
    
    update_table $1 $2 ${data[@]}
    case $? in
        0) zenity --width=300 --info --text="Row updated successfully!";;
        1) zenity --width=300 --error --text="Error: Invalid datatype!";;
    esac

}