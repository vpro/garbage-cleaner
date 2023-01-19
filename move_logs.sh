#!/usr/bin/env bash

# Script to move away and zip log files
# Per folder there are the following stages:
#   - Make sure a subdir OLD exists
#   - Remove all files therein modified over 30 days ago
#   - In the log folder itself gzip all files over 1 day old, and move them to OLD
#   
#  30 days and 1 day are just defaults, and can be overridden
#  E.g. zip after 2 hours, delete after 6 days.
#  ./move_logs.sh /data/logs:-mmin +120:-mtime +6


default_fileage_to_delete=("-mtime" "+30")
default_fileage_to_zip=("-mtime" "+1")
#set -x
# delete action, can be overridden via environment for debuggin
action=${ACTION:-'-delete'}
# Files to zip. Only those that are rotated away, and hence contain '<year>-' in the filename.
regex=${REGEX:-'.*2[0-9][0-9][0-9]\-.*'}

IFS=','
read -ra target_folders <<< "$1"
for i in "${!target_folders[@]}"; do
  IFS=':'; read -ra folder_array <<< ${target_folders[$i]}
  folder=${folder_array[0]}
  length=${#folder_array[@]}
 
  fileage_to_zip=("${default_fileage_to_zip[@]}")
  if [ $length -gt 1 ] ; then
    if [ "${folder_array[1]}" != ''  ] ; then
       IFS=' '; read -ra fileage_to_zip <<< ${folder_array[1]}
    fi
  fi
  fileage_to_delete=("${default_fileage_to_delete[@]}")
  if [ $length -gt 2 ] ; then
    if [ "${folder_array[2]}" != '' ] ; then
       IFS=' '; read -ra fileage_to_delete <<< ${folder_array[2]}
    fi
  fi

  OLD="$folder/OLD"
  mkdir -p "$OLD"
  echo "Removing old gz-files in $OLD"
  find "$OLD" -maxdepth 1 -type f  -name "*.gz" "${fileage_to_delete[@]}" -exec echo "removing " {} \; ${action}
  echo "Zipping files (that are not linked, and not zipped already) in $folder and moving them to $OLD"
  find "$folder" -maxdepth 1 -type f  "${fileage_to_zip[@]}" -regex "${regex}" -not -name '*.gz'  -exec  sh -c 'if [ 1 == $(find -samefile $1  | wc -l) ] ; then echo zipping $1 ; gzip $1; else echo not zipping $1 because is linked \($(find -samefile $1)\) ; fi' shell {} \; -exec touch {}.gz \; -exec mv {}.gz "$OLD/" \;
done
