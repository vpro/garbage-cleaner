#!/usr/bin/env bash

read -a target_folders <<< "$1"
mark=${MARK:-''} # default is no mark, this is meant to mean 'access time'
fileage=${FILE_AGE:-'1d'}

for i in "${!target_folders[@]}"; do
  folder=${target_folders[$i]}

  printf "Recursive deleting files in: \"%s\" older then %s\n" $folder $fileage

  tmpreaper --showdeleted $mark $fileage $folder
done
