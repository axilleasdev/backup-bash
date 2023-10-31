#!/bin/bash

# Check the number of arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 source_directory destination_directory"
  exit 1
fi

sourceDir="$1"
destDir="$2"

# Check if the source and destination directories exist
if [ ! -d "$sourceDir" ] || [ ! -d "$destDir" ]; then
  echo "Invalid directory path provided"
  exit 1
fi

# Get current timestamp
currentTS=$(date '+%s')

# Create backup filename
backupFileName="backup-$currentTS.tar.gz"

# Move to the source directory
cd "$sourceDir" || exit 1

# Get the list of files modified in the last 24 hours
toBackup=()
yesterdayTS=$((currentTS - 24 * 60 * 60))

for file in *; do
  fileTS=$(date -r "$file" '+%s")
  if [ "$fileTS" -gt "$yesterdayTS" ]; then
    toBackup+=("$file")
  fi
done

# Create a tarball of the selected files
tar -czvf "$backupFileName" "${toBackup[@]}"

# Move the backup file to the destination directory
mv "$backupFileName" "$destDir"

echo "Backup completed successfully: $destDir/$backupFileName"

## THATS ALL 
