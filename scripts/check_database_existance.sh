#!/bin/bash


check_database_existance(){
    res=1
    if [  -d "databases/$1" ]; then
        res=0
    fi
    return $res
}