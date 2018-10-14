#!/usr/local/bin/bash

declare -A users
excludedFolders="-path ./lib"
excludedFolders="$excludedFolders -o -path ./Movistar-sources/libraries/fb-connect-ios-sdk"
excludedFolders="$excludedFolders -o -path ./Movistar-sources/libraries/OAuthConsumeriPhoneLib"
excludedFolders="$excludedFolders -o -path ./Movistar-sources/libraries/SAOAuthTwitterEngine"
excludedFolders="$excludedFolders -o -path ./Movistar-sources/libraries/UIAlertViewManager"
excludedFolders="$excludedFolders -o -path ./Movistar-sources/Mirada/libraries/library-iris-ios-components/lib/library-iris-ios-interface/lib"
excludedFolders="$excludedFolders -o -path ./Movistar-sources/Mirada/libraries/library-iris-ios-components/lib/library-iris-ios-interface/src/IrisInterface/libs"
excludedFolders="$excludedFolders -o -path ./Movistar-sources/libraries/IrisPlayer/IrisPlayer/ThirdParty"
excludedFolders="$excludedFolders -o -path ./Movistar-sources/Mirada/Movistar/src/Movistar/Third*"

files=$(find -E . -type d \( $excludedFolders \) -prune -o -iregex ".*\.(swift|m|h|xib|storyboard)")

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