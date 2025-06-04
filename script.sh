#!/bin/bash

# Fixed OBS Archiver Script
SOURCE="/mnt/standarddata"
DEST="/mnt/archivedata"

# Create destination directory if it doesn't exist
mkdir -p "$DEST"

# Find and move files older than 5 minutes
find "$SOURCE" -type f -mmin +5 -print0 | while IFS= read -r -d '' file; do
    # Get relative path without source directory
    rel_path="${file#$SOURCE/}"
    
    # Create destination path
    dest_file="$DEST/$rel_path"
    
    # Create destination directory if needed
    mkdir -p "$(dirname "$dest_file")"
    
    # Move the file with verbose output
    if mv -v "$file" "$dest_file"; then
        echo "Successfully moved: $file to $dest_file"
    else
        echo "Failed to move: $file" >&2
    fi
done