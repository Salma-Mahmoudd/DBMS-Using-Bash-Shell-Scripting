#!/bin/bash

# update_table: update table data
# $1: table name
# $2: primary key value
# $3: column name and it's updated value (e.g., column2:2)
#
# Return:
# 0 if success,
# 1 if arguments do not exist
# 2 if table does not exist,
# 3 column doesn't exist
# 4 if invalid data type

update_table(){
    typeset -i res ind

    if [ $# -lt 3 ]
    then
        res=1
    elif [ ! -f "$1" ]
    then
        res=2
    else
        metadata=`grep "^$1;" metadata`
        id=$2
        column=`echo $3 | cut -d: -f1`
        value=`echo $3 | cut -d: -f2`
        result=$(echo $metadata | awk -v column="$column" -v value="$value" -F';' '
        {   
            res=3
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
                }else{
                    res=3;
                }
            }
        } END{ print res, ind }')
        read res ind <<< "$result"
        if [ $res -eq 0 ]
        then
            awk -F':' -v pat="$id" -v ind="$ind" -v val="$value" '{
                if($0 ~ "^" pat){ $ind = val } ;
                print 
            }' OFS=':' $1 > temp.txt && mv temp.txt $1
        fi
    fi
    return $res
}