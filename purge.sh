#!/usr/bin/env bash

read -d, -a target_folders <<< "$1"
mark=${MARK:-'-atime'}
fileage=${FILE_AGE:-'1'}

for i in "${!target_folders[@]}"; do
  folder=${target_folders[$i]}
  printf "Recursive deleting files in: ""%s"" older then %s\n" $folder $fileage
  # mindepth 1: don't include the base directories as things to delete
  find "$folder" -type f $mark +$fileage -delete
  find "$folder" -mindepth 1 -type d $mark +$fileage -empty -delete
  echo "Done"
done
