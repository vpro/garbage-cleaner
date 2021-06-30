#!/usr/bin/env bash

IFS=','
read -r -a target_folders <<< "$1"
for i in "${!target_folders[@]}"; do
  folder=${target_folders[$i]}
  OLD="$folder/OLD"
  mkdir -p "$OLD"
  find "$folder" -type f -maxdepth 1 -mtime +3 -not -name "*.gz" -exec gzip {} \; -exec mv {}.gz "OLD/" \;
  find "$OLD" -type f -name "*.gz" -mtime +30 -exec echo "removing " {} \; -exec gzip {} \;
done
