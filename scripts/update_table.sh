#!/bin/bash

# update_table: update table data
# $1: database name
# $2: table name
# $3: condition column name and value (e.g., column2:2)
# $3: column name and it's updated value (e.g., column2:2)

# Return:
# 0 if success,
# 1 invalid datatype

update_table(){
    typeset -i res=0 ind i=0 indices[2]
    local values[2]
    local database=$1
    local file=$2
   
    shift 2
    
    metadata=`grep "^$file;" ./databases/$database/metadata`
    while (( $# > 0 && $res == 0 ))
        do
            
            column=`echo $1 | cut -d: -f1`
            value=`echo $1 | cut -d: -f2`
            result=$(echo $metadata | awk -v column="$column" -v value="$value" -F';' '
            {
                for(i=2; i<=NF; i++) {
                    split($i, arr, ":");
                    res=1
                    if (arr[1] == column )  {
                        if((arr[2] == "int" && value ~ /^-?[0-9]+$/) || \
                        (arr[2] == "string" && value !~ /:/) || \
                        (arr[2] == "float" && value ~ /^-?[0-9]+(.[0-9]+)?$/) || \
                        (value == ""))
                        {
                            ind=i-1;
                            res=0;
                        }
                        break;
                    }
                }
            } END{ print res, ind }')
            read res ind <<< "$result"
            values[$i]=$value
            indices[$i]=$ind
            ((i++))
            shift
    done
    if [ $res -eq 0 ];  then
        awk -F':' -v keyval="${values[0]}" -v value="${values[1]}" -v key="${indices[0]}" -v ind="${indices[1]}" '
        {
            if ($key == keyval) {
                $ind = value;
            }
            print;
        }' OFS=':' ./databases/$database/$file > temp.txt && mv temp.txt ./databases/$database/$file

    fi
    return $res
}