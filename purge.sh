#!/usr/bin/env bash

read -a target_folders <<< "$1"
mark=${MARK:-'-atime'}
fileage=${FILE_AGE:-'1d'}

for i in "${!target_folders[@]}"; do
  folder=${target_folders[$i]}

  printf "Recursive deleting files in: \"%s\" older then %s\n" $folder $FILE_AGE

  tmpreaper --showdeleted $mark $FILE_AGE $folder
done
