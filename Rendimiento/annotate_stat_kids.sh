#!/usr/local/bin/bash

declare -A users
exludedFolders="-type d \\( -path ./Pods -o -path ./Kids/KidsLibrary/Pods -o -path ./Kids/IrisPlayer \\) -prune -o"

files=$(find -E . -type d \( -path ./Pods -o -path ./Kids/KidsLibrary/Pods -o -path ./Kids/IrisPlayer \) -prune -o -iregex ".*\.(swift|m|h)")

for file in $files
do
  annotate=$(hg annotate -u $file | cut -d':' -f1)

  for user in $annotate
  do
    if [[ ${users[$user]} ]]; then
      (( users[$user]++ ))
    else
      users[$user]=1
    fi
  done
done

echo ""

for user in "${!users[@]}"
do
  echo $user: ${users[$user]}
done