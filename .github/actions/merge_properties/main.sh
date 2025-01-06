#!/bin/bash

source_file=$1
target_file=$2

# Read properties from source file
while IFS= read -r line
do
  key=$(echo "$line" | cut -d '=' -f1)
  value=$(echo "$line" | cut -d '=' -f2-)
  # Check if key already exists in target file
  grep -q "^$key=" "$target_file" && continue
  echo "$key=$value" >> "$target_file"
done < "$source_file"

echo "Merged properties from $source_file to $target_file"