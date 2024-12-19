#!/bin/bash -x

# update_table: update table data
# $1: table name
# $2: search column and value
# $3: column name and it's updated value (e.g., column2:2)
#
# Return:
# 0 if success,
# 1 duplicate primary key
# 2 invalid datatype

update_table(){
    typeset -i res=0 ind i=0 indices[2]
    local  values[2]

   
    
    metadata=`grep "^$1;" "/databases/$1/metadata"`
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
                    res=4
                    if (arr[1] == column )  {
                        if(arr[2] == "int" && value ~ /^-?[0-9]+$/ 
                        || arr[2] == "string" && value !~ /:/  
                        || arr[2] == "float" && value ~ /^-?[0-9]+(.[0-9]+)?$/ )
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
    if [ $res -eq 0 &&  ${indices[1]} -eq 1 ]; then
        res=$(grep -wc "^${values[1]}:" /database/$1/$2)
    fi

    if [ $res -eq 0 ];  then
        awk -F':' -v keyval="${values[0]}" -v value="${values[1]}" -v key="${indices[0]}" -v ind="${indices[1]}" '
        {
            if ($key == keyval) {
                $ind = value;
            }
            print;
        }' OFS=':' "/databases/$1/$2" > temp.txt && mv temp.txt "/databases/$1/$2"

    fi
    return $res
}