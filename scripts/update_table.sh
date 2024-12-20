#!/bin/bash

# update_table: Update table data in the specified database.
#
# This function updates specific columns in a table based on given conditions.
# It checks the datatype of the column, validates the input, and modifies the table entries accordingly.
#
# Parameters:
#   $1 - The name of the database.
#   $2 - The name of the table.
#   $3 - The condition for the column to be updated (e.g., "column2:2").
#   $4 - The column name and the new value to update (e.g., "column2:3").
#
# Returns:
#   0 - Success (data updated).
#   1 - Invalid datatype or other error.
#
# Example:
#   update_table "my_database" "my_table" "column2:2" "column3:new_value"
#   Output: Updates column3 with "new_value" for rows where column2 equals 2 in "my_table".

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