#!/usr/bin/env bash

target_folders=($(echo ${TARGET_FOLDERS:-''} | tr "," "\n"))
mark=($(echo ${MARK:-''}))

for i in "${!target_folders[@]}"; do
  folder=${target_folders[$i]}

  printf "Recursive deleting files in: \"%s\" older then %s\n" $folder $FILE_AGE

  tmpreaper --showdeleted $mark $FILE_AGE $folder
done
