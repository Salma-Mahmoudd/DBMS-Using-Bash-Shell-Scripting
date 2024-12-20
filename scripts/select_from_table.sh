#!/bin/bash

# select_from_table: Select specific columns from a table based on conditions.
#
# This function extracts specific columns from a table in the specified database, filtering rows based on conditions.
# It reads metadata to identify column indices and applies filters to match rows based on the specified conditions.
#
# Parameters:
#   $1 - The name of the database.
#   $2 - The name of the table.
#   $3 - The condition for filtering rows, specified as "column:value" pairs.
#
# Returns:
#   A formatted output of selected columns from the table matching the condition.
#
# Example:
#   select_from_table "my_database" "my_table" "column1:10" "column2:active"
#   Output: Extracts and displays rows from "my_table" in "my_database" where column1 equals 10 and column2 equals "active".

function select_from_table(){

    typeset -i res=0 ind i=0 indices[2]
    local columns[2]
    local database=$1
    local table=$2
    local condition=$3
    local condition_ind=0
    local value=0

    shift 2
    if [ $1 = ":" ]; then
        shift
    else
        set -- `echo $condition | cut -d: -f1` "${@:2}"
    fi
    
    metadata=`grep "^$table;" databases/$database/metadata`
    while (( $# > 0 ))
    do
        ind=$(echo $metadata | awk -F';' -v column="$1" '
        {
            for(i=2; i<=NF; i++) {
                split($i, arr, ":");
                if (arr[1] == column )  {
                    ind = i - 1;
                    break;
                }
            }
        } END{ print ind }')

        if [ $i -eq 0 ] && [ $condition != ":" ]; then
            condition_ind=$ind
            value=$(echo $condition | cut -d: -f2)
        else
            indices[$i]=$ind
            columns[$i]=$1
        fi
        ((i++))
        shift
    done
    row=""
    for name in ${columns[@]}
    do
        row="$row$name\t\t"
    done
    row="$row\n$(awk -F: -v indices="${indices[*]}" -v size=${#indices[@]} -v condition_ind="$condition_ind" -v value="$value" '{
    split(indices, indicesArr, " ");
    if (!condition_ind || $condition_ind == value) {
        for (ind in indicesArr) {
            row = row $indicesArr[ind] "\t\t"
        }
        row = row "\n";
    }
    } END { print row }' databases/$database/$table)"   
    echo -e "$row"
}