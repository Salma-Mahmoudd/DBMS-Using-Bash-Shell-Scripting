#!/bin/bash

function get_table_name(){
	local table_name

	table_name=$(zenity --width=400 --height=150 --entry \
		--title="Table" \
		--text="Enter the table name:")

	echo "$table_name"
}