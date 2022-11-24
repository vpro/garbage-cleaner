#!/usr/bin/env bash
#set -x
# This script will delete all files in a number of directories (and their subdirectories) older then a certain age
# params: <folder 1>[:<mark>[:<age>]][,<folder 2>[:<mark>[:<age>]]]...



IFS=','; read -ra target_folders <<< "$1"
default_mark=${MARK:-'-atime'}
default_fileage=${FILE_AGE:-'1'}
action=${ACTION:-'-delete'}

for i in "${!target_folders[@]}"; do
  # split it with colons: directory[:<mark>:[<age>]]
  # if mark or age are unspecified they fall back to MARK and FILE_AGE environments
  IFS=':'; read -ra folder_array <<< ${target_folders[$i]}
  folder=${folder_array[0]}
  length=${#folder_array[@]}
  mark=$default_mark
  if [ $length -gt 1 ] ; then
    if [ ${folder_array[1]} != ''  ] ; then
      mark=${folder_array[1]}
    fi
  fi
  fileage=$([ $length -gt 2 ] && echo "${folder_array[2]}" || echo  "$default_fileage" )
  printf "Recursive deleting (%s) files in: ""%s"" older then %s (%s))\n" $action $folder $fileage $mark
  # mindepth 1: don't include the base directories as things to delete
  find "$folder" -type f $mark +$fileage $action

  # for directories: always mtime, e.g. placing a file in a directory will _not_ change it's atime.
  find "$folder" -mindepth 1 -type d ${mark/a/m} +$fileage -empty $action
  echo "Done"
done
