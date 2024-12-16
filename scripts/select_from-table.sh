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
# 3 column doesn't exist

select_from_table(){
    typeset -i res=0 ind i=0 arr[2]
    typeset  columns[2]

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
        awk -F: -v num=$2 '{
            row=""
            for(i=1; i<= NF && (!num || NR <= num); i++) {
                row = row $i "\t\t"
            };
            if(num && NR <= num || !num) print row;
        }' $1
    else
        file=$1
        limit=$2
        shift 2
        metadata=`grep "^$file;" metadata`
        while (( $# > 0 && $res != 3 ))
        do
            result=$(echo $metadata | awk -v column="$1"  -F';' '
            {   res = 3;
                for(i=2; i<=NF; i++) {
                    split($i, arr, ":");
                    if (arr[1] == column )  {
                        res = 0;
                        ind = i - 1;
                        break;
                    }
                }
            } END{ print res, ind }')
            read res ind <<< "$result"
            arr[$i]=$ind
            columns[$i]=$1
            ((i++))
            shift
        done
        if [ $res -eq 0 ]
        then
            row=""
            for name in ${columns[@]}
            do
                row="$row$name\t\t"
            done
            echo -e "$row"
            awk -F: -v num=$limit  -v arr="${arr[*]}" -v size=${#arr[@]} '{
                row="";
                split(arr, indices, " ")
                for(i=1 ; i <= size && (!num || NR <= num); i++) {
                    row = row $indices[i] "\t\t"
                }
                if(num && NR <= num  || !num) print row;
            }' $file
        fi
    fi
    return $res
}