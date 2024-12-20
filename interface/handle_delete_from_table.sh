#!/bin/bash
set -x
source ./scripts/get_table_columns.sh
source ./scripts/num_columns_of_table.sh

function handle_delete_from_table(){
    typeset -i num_columns
    local list columns_name col_name data db_name=$1 table_name=$2
    local -a list

    num_columns_of_table "$1" "$2"
    num_columns="$?"
    read -r -a columns_name <<< "$(get_table_columns "$db_name" "$table_name")"

    list+=(true "${columns_name[0]}")
    for (( i = 1; i < num_columns; i++ )); do
        list+=(false "${columns_name[$i]}")
    done

    col_name=$(zenity --list \
    --column="Select" --column="Column name" \
    "${list[@]}" \
    --radiolist)

    echo "$col_name"
}