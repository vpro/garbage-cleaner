#!/usr/bin/env bash

target_folders=($(echo ${TARGET_FOLDERS:-''} | tr "," "\n"))

printf "Starting garbage cleaner for target_folders %s\n" $TARGET_FOLDERS

while true; do

    for i in "${!target_folders[@]}"; do
      folder=${target_folders[$i]}

      printf "Recursive deleting files in: %s older then %s minutes\n" $folder $FILE_AGE_MINUTES

      tmpreaper ${FILE_AGE_MINUTES}m $folder
    done

    sleep ${INTERVAL_MINUTES}m

done

