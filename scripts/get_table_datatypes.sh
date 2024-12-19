#!/bin/bash
#$1 database name
#$2 table name

function get_table_datatypes() {
    local columns

    columns=$(grep "^$2;" "./databases/$1/metadata" \
        | awk -F";" '{ for (i=2; i<=NF; i++) print $i }' \
        | cut -d: -f2)

    echo $columns
}