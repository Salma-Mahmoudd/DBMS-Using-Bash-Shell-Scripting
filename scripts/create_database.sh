#!/bin/bash

if [[ -n "$1" && ! -d "$1" && "$1" =~ ^[a-zA-Z0-9._]+$ ]]; then
    mkdir "$1" && touch ./"$1"/metadata
else
    exit 1
fi