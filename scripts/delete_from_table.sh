#!/bin/bash



function delete_from_table(){
    typeset -i field_num
    local field_name to_remove table_path

    table_path="./databases/$1/$2"
    field_name=$3
    to_remove=$4

    awk -F: -v f="$field_num" -v val="$to_remove" \
        '$f != val {print $0}' \
        "$table_path" > temp && mv temp "$table_path"
}