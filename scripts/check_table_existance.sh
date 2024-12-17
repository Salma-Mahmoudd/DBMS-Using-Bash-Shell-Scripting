#!/bin/bash


check_table_existance(){
    res=1
    if [  -f "databases/$1" ]; then
        res=0
    fi
    return $res
}