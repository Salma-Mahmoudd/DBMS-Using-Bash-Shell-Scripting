#!/bin/bash
# select_from_table: select table data
# $1: database name
# $2: table name
# rest of input are condition and columns
#
# Return:
# 0 if success,

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