#!/bin/bash

# select_from_table: select table data
# $1: table name
# $2: number of records if 0 all the records
# $3: columns name if not provided all columns
#
# Return:
# 0 if success,
# 1 if arguments do not exist
# 2 if table does not exist

select_from_table(){
    typeset -i res ind

    if [ $# -lt 2 ]
    then
        res=1
    elif [ ! -f "$1" ]
    then
        res=2
    elif [ $# -eq 2 ]
    then
        awk -F';' '{
            for(i=2; i<=NF; i++) {
                split($i, arr, ":");
                row = row arr[1] "\t\t"
            };
            print row

        }' metadata
        awk -F: -v num=$num '{
            while((!num || NR <= num) && i<= NF){
                for(i=1; i<= NF; i++) {
                    row = row $i "\t\t"
                };
                print row
            }
        }' $1
        
    fi
    return $res
}