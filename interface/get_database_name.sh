#!/bin/bash

function get_database_name(){
	local db_name

	db_name=$(zenity --width=400 --height=150 --entry \
		--title="Database" \
		--text="Enter the database name:")

	echo "$db_name"
}