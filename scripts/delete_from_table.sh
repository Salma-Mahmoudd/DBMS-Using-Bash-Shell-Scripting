#!/bin/bash

source ./scripts/get_table_columns.sh

function delete_from_table(){
    typeset -i field_num i=1
    local field_name field_val table_path ت
    local -a columns_name

    read -r -a columns_name <<< "$(get_table_columns "$1" "$2")"
    table_path="./databases/$1/$2"
    field_name=$3
    field_val=$4

    for j in "${columns_name[@]}"; do
        if [[ "${j}" == "${field_name}" ]]; then
            field_num=$((i))
            break
        fi
        ((i++))
    done

    awk -F: -v f="$field_num" -v val="$field_val" \
        '$f != val {print $0}' \
        "$table_path" > temp && mv temp "$table_path"
}