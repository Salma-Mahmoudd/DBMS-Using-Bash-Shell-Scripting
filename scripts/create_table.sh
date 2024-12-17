#!/bin/bash

# create_table: create table in specific database and its metadata. First column must be a primary key
# $1: table name
# $2 $3...: column names and their types (e.g., column1 primary:string, column2:int)
#
# Return: 0 if success, 1 if arguments do not exist, 2 if table exists,
# 3 if invalid syntax and 4 if there is no primary key


function create_table() {
    
    echo "$2$3" >> "./databases/$1/metadata"
    touch "./databases/$1/$2"       
    
}