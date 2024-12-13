#!/bin/bash

# create_database: create database folder
# $1: database name
#
# Return: 0 if success, 1 if argument does not exist,
# 2 if database already exists and 3 if invalid name format

function create_database() {
    local success=0

    if [[ -z "$1" ]]; then
        success=1
    elif [[ -d "./databases/$1" ]]; then
        success=2
    elif [[ ! "$1" =~ ^[a-zA-Z0-9._]+$ ]]; then
        success=3
    else
        mkdir -p "./databases/$1" && touch "./databases/$1/metadata"
    fi

    return $success
}
