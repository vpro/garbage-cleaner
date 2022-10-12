#!/usr/bin/env bash
#set -x

IFS=','; read -ra target_folders <<< "$1"
default_mark=${MARK:-'-atime'}
default_fileage=${FILE_AGE:-'1'}
action=${ACTION:-delete}

for i in "${!target_folders[@]}"; do
  # split it with colons: directory[:<mark>:[<age>]]
  # if mark or age are unspecified they fall back to MARK and FILE_AGE environments
  IFS=':'; read -ra folder_array <<< ${target_folders[$i]}
  folder=${folder_array[0]}
  length=${#folder_array[@]}
  mark=$([ $length -gt 1 ] -a [ ${folder_array[1]} != '' ] && echo "${folder_array[1]}" || echo  "$default_mark" )
  fileage=$([ $length -gt 2 ] && echo "${folder_array[2]}" || echo  "$default_fileage" )
  printf "Recursive deleting files in: ""%s"" older then %s (%s))\n" $folder $fileage $mark
  # mindepth 1: don't include the base directories as things to delete
  find "$folder" -type f $mark +$fileage $action

  # for directories: always mtime, e.g. placing a file in a directory will _not_ change it's atime.
  find "$folder" -mindepth 1 -type d ${mark/a/m} +$fileage -empty $action
  echo "Done"
done
