#!/usr/bin/env bash

IFS=','
read -r -a target_folders <<< "$1"
for i in "${!target_folders[@]}"; do
  folder=${target_folders[$i]}
  OLD="$folder/OLD"
  mkdir -p "$OLD"
  echo "Removing old files in $OLD"
  find "$OLD" -maxdepth 1  -type f  -name "*.gz" -mtime +30 -exec echo "removing " {} \; -delete
  echo "Zipping files in $folder and moving them to $OLD"
  find "$folder" -maxdepth 1 -type f  -mtime +1 -not -name '*.gz' -exec echo zipping {} \; -exec gzip {} \; -exec touch {}.gz \; -exec mv {}.gz "$OLD/" \;
done
