#!/usr/bin/env bash

read -d, -a target_folders <<< "$1"
mark=${MARK:-'-atime'}
fileage=${FILE_AGE:-'1'}

for i in "${!target_folders[@]}"; do
  folder=${target_folders[$i]}
  printf "Recursive deleting files in: ""%s"" older then %s\n" $folder $fileage
  # mindepth 1: don't include the base directories as things to delete
  find "$folder" -type f $mark +$fileage -delete

  # for directories: always mtime, e.g. placing a file in a directory will _not_ change it's atime.
  find "$folder" -mindepth 1 -type d -mtime +$fileage -empty -delete
  echo "Done"
done
