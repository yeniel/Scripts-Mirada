#!/usr/local/bin/bash

declare -A users
excludedFolders="-path ./library-3rd-android-nexplayer"
excludedFolders="$excludedFolders -o -path ./library-3rd-android-nexplayer-lott"
excludedFolders="$excludedFolders -o -path ./library-3rd-android-nexplayer-dvb"
excludedFolders="$excludedFolders -o -path ./library-3rd-android-view-right-web-client"
excludedFolders="$excludedFolders -o -path ./.idea"
excludedFolders="$excludedFolders -o -path ./build"
excludedFolders="$excludedFolders -o -path ./.hg"
excludedFolders="$excludedFolders -o -path ./.gradle"
excludedFolders="$excludedFolders -o -path ./scripts"
excludedFolders="$excludedFolders -o -path ./components"
excludedFolders="$excludedFolders -o -path ./viewpagerindicator"
excludedFolders="$excludedFolders -o -path ./player/build"
excludedFolders="$excludedFolders -o -path ./tvmetrix/build"
excludedFolders="$excludedFolders -o -path ./tvmetrix/.hg"
excludedFolders="$excludedFolders -o -path ./app/build"
excludedFolders="$excludedFolders -o -path ./app/.hg"
excludedFolders="$excludedFolders -o -path ./interface/.hg"
excludedFolders="$excludedFolders -o -path ./interface/build"

files=$(find -E . -type d \( $excludedFolders \) -prune -o -iregex ".*\.(java|xml)")

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