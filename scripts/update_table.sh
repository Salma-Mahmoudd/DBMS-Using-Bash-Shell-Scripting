#!/bin/bash -x

# update_table: update table data
# $1: table name
# $2: search column and value
# $3: column name and it's updated value (e.g., column2:2)
#
# Return:
# 0 if success,
# 1 if arguments do not exist
# 2 if table does not exist,
# 3 column doesn't exist
# 4 if invalid data type

update_table(){
    typeset -i res=0 ind i=0 arr[2]
    typeset  columns[2]

    if [ $# -lt 3 ]
    then
        res=1
    elif [ ! -f "$1" ]
    then
        res=2
    else
        metadata=`grep "^$1;" metadata`
        file=$1
        shift
        while (( $# > 0 && $res == 0 ))
        do
            column=`echo $1 | cut -d: -f1`
            value=`echo $1 | cut -d: -f2`
            result=$(echo $metadata | awk -v column="$column" -v value="$value" -F';' '
            {   res = 3;
                for(i=2; i<=NF; i++) {
                    split($i, arr, ":");
                    if (arr[1] == column )  {
                        if(arr[2] == "int" && value ~ /^[0-9]+$/ || arr[2] == "string" ){
                         ind=i-1;
                         res=0;
                     }else{
                         res=4;
                     };
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
        if [ $res -eq 0 ]
        then
           awk -F':' -v keyval="${values[0]}" -v value="${values[1]}" -v key="${indices[0]}" -v ind="${indices[1]}" '
           {
                 if ($key == keyval) {
                     $ind = value;
                    }
             print;
            }' OFS=':' "$file" > temp.txt && mv temp.txt "$file"

        fi
    fi
    return $res
}