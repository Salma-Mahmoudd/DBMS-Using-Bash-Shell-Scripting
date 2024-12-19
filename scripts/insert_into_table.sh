#!/bin/bash

source ./scripts/num_columns_of_table.sh
source ./scripts/get_table_datatypes.sh

function insert_into_table(){
    typeset -i err num_columns i
    local table_path pk val
    local -a column_values table_datatypes

    err=0
    num_columns_of_table "$1" "$2"
    num_columns="$?"
    table_path="./databases/$1/$2"
    read -r -a table_datatypes <<< "$(get_table_datatypes "$1" "$2")"
    shift 2
    column_values="$*"
    pk=$(echo "$column_values" | cut -d: -f1)

    if [[ -z $pk ]]; then
        err=1
    elif grep -qE "^$pk:" "$table_path"; then
        err=2
    else
        for (( i = 1; i <= num_columns && err==0; i++ )); do
            val=$(echo "$column_values" | cut -d: -f"$i")
            if [[ -n $val ]]; then
                case ${table_datatypes[$i - 1]} in
                    "int") if [[ ! $val =~ ^-?[0-9]+$ ]]; then err=3; fi;;
                    "float") if [[ ! $val =~ ^-?[0-9]+(.[0-9]+)?$ ]]; then err=3; fi;;
                    "string") if [[ $val =~ : ]]; then err=3; fi;;
                esac
            fi
        done
    fi
    if [[ $err == 0 ]]; then
        (echo "${column_values[*]}" >> "$table_path")
    fi

    return "$err"
}