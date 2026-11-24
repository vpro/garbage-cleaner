#!/usr/bin/env bash
#set -x
# This script will delete all files in a number of directories (and their subdirectories) older then a certain age
# params: <folder 1>[:<file criteria>[:<directory criteria>]][,<folder 2>[:<file criteria>[:<directory criteria>]]]...
#
# <file criteria> are find arguments, default '-atime +30'. E.g. '-mtime +365 ! -name config.properties'
# <directory criteria> are find arguments for removing empty directories. Defaults to the first two words of
# <file criteria>, with atime/amin replaced by mtime/mmin. E.g. '-mtime +365 -path */.camel/*' to only remove empty
# directories inside .camel directories.


default_fileage=("-atime" "+30")
action=${ACTION:-'-delete'}
find_cmd=${FIND:-find}


IFS=','
read -ra target_folders <<< "$1"
for i in "${!target_folders[@]}"; do
  # split it with colons: directory[:<file criteria>[:<directory criteria>]]
  IFS=':'; read -ra folder_array <<< "${target_folders[$i]}"
  folder=${folder_array[0]}
  length=${#folder_array[@]}
  fileage=("${default_fileage[@]}")
  if [ "$length" -gt 1 ] ; then
    if [ "${folder_array[1]}" != ''  ] ; then
      IFS=' '; read -ra fileage <<< "${folder_array[1]}"
      # whitespace only criteria would match (and delete) everything, fall back to the default
      if [ "${#fileage[@]}" -eq 0 ] ; then
        fileage=("${default_fileage[@]}")
      fi
    fi
  fi
  # mindepth 1: don't include the base directories as things to delete
  echo "Removing files in $folder with command" "${fileage[@]}"
  
  $find_cmd "$folder" -mindepth 1 -type f "${fileage[@]}" -printf "$FORMAT" "${action}"


  # This will clean up empty directory, not yet the ones that were just emptied.
  # that will probably happen 1 or 2 runs later.
  # for directories: always mtime, e.g. placing a file in a directory will _not_ change it's atime.
  dirtime=${fileage[0]/atime/mtime}
  dirtime=${dirtime/amin/mmin}
  dirage=("$dirtime" "${fileage[1]}")
  if [ "$length" -gt 2 ] ; then
    if [ "${folder_array[2]}" != ''  ] ; then
      IFS=' '; read -ra dirage_override <<< "${folder_array[2]}"
      # ignore whitespace only criteria, keep the default
      if [ "${#dirage_override[@]}" -gt 0 ] ; then
        dirage=("${dirage_override[@]}")
      fi
    fi
  fi
  echo "Removing directories in $folder with command" "${dirage[@]}"
  $find_cmd "$folder" -mindepth 1 -type d "${dirage[@]}" -empty -printf "$FORMAT" "${action}"

  echo "Done"
done
