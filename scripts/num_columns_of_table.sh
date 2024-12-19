#!/bin/bash

function num_columns_of_table(){
    typeset -i num_columns
    local meta_path

    meta_path="./databases/$1/metadata"
    num_columns=$(awk -F';' -v table_name="$2" \
        '{if ($1 == table_name) print NF - 1}' \
        "$meta_path")

    return "$num_columns"
}