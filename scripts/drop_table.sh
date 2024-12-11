#!/bin/bash

if [[ -n "$1" && -f "$1" ]]; then
    rm "$1"
else
    exit 1
fi