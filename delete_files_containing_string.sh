#!/bin/bash

# Function to delete files recursively
delete_files() {
    local pattern="$1"
    local dir="$2"

    # Traverse the directory recursively
    for file in "$dir"/*; do
        if [ -d "$file" ]; then
            # If it's a directory, call the function recursively
            delete_files "$pattern" "$file"
        elif [[ "$file" == *$pattern*  ]]; then
            # If the file name contains the pattern, delete it
            rm -f "$file"
            echo "Deleted: $file"
        fi
    done
}

# Check if a directory is provided as an argument
if [ -n "$2" ] && [ -d "$2" ]; then
    delete_files "$1" "$2"
else
    echo "Usage: $0 <pattern> <directory>"
    exit 1
fi
