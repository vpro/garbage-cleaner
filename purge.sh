#!/usr/bin/env bash
#set -x
# This script will delete all files in a number of directories (and their subdirectories) older then a certain age
# params: <folder 1>[:<mark> <age>][,<folder 2>[:<mark> <age>]]...


default_fileage=("-atime" "+30")
action=${ACTION:-'-delete'}



IFS=','
read -ra target_folders <<< "$1"
for i in "${!target_folders[@]}"; do
  # split it with colons: directory[:<mark>:[<age>]]
  # if mark or age are unspecified they fall back to MARK and FILE_AGE environments
  IFS=':'; read -ra folder_array <<< ${target_folders[$i]}
  folder=${folder_array[0]}
  length=${#folder_array[@]}
  fileage=("${default_fileage[@]}")
  if [ $length -gt 1 ] ; then
    if [ ${folder_array[1]} != ''  ] ; then
      IFS=' '; read -ra fileage <<< ${folder_array[1]}
    fi
  fi
  # mindepth 1: don't include the base directories as things to delete
  echo "Removing files in $folder with command" "${fileage[@]}"
  find "$folder" -maxdepth 1 -type f "${fileage[@]}" -exec echo "removing " {} \; ${action}

  # for directories: always mtime, e.g. placing a file in a directory will _not_ change it's atime.
  echo "Removing directories in $folder with command -mtime ${fileage[1]}"
  find "$folder" -maxdepth 1 -type d -mtime "${fileage[1]}" -empty -exec echo "removing " {} \; ${action}

  echo "Done"
done
