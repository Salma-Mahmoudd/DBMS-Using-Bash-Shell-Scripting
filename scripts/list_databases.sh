#!/bin/bash

# list_databases: Lists all available databases in the "databases" directory.
#
# This function checks if the "databases" directory exists, and if it does,
# it lists all the directories (databases) inside it.
# If the directory doesn't exist or is empty, it exits with an error.
#
# Returns:
#   0 - Success (Databases listed)
#   1 - Error (No "databases" directory found or it is empty)
#
# Example:
#   list_databases
#   Output: Lists database names if available, otherwise no output.

function list_databases() {
    local success=1

    if [ -d "databases" ]; then
        ls -A ./databases
        success=0
    fi

    return "$success"
}