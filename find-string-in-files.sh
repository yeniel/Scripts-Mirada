#!/bin/bash

declare -a keys
let index=0
keysFile="keys_file"

while IFS='' read -r line || [[ -n "$line" ]]; do
	keys[i]="${line}"
	((++i))
done < "$keysFile"

for key in "${keys[@]}"; do
	
	printf "\n\nKEY: $key\n\n"
    matches=$(grep --include=\*.{m,h,swift,strings,plist} -r /Users/yeniel.landestoy/workspace/ios/product-iris-mobile -e "$key")
    echo "$matches" | sed 's/\/Users\/yeniel.landestoy\/workspace\/ios\/product-iris-mobile\/Iris\/src\/View//g'

    matchesNumberOfLines=$(echo "$matches" | wc -l)
    localizableMatchesNumberOfLines=$(echo "$matches" | grep -e "\.strings:$key" | wc -l)

    if [[ $matchesNumberOfLines -eq $localizableMatchesNumberOfLines ]]; then
		echo "$matches" | cut -d : -f 1 | while read -r file ; do
			sed -i "" -e "/$key/d" $file
			sed -i "" -e "/$key/d" $keysFile
		done
	else
		printf "\n\nNO DELETE\n"
	fi

	# while true; do
	# 	echo ""
	# 	read -n 1 -p "Delete? y/n " delete
	# 	echo ""

	# 	if [[ $delete =~ ^[y]$ ]]; then
	# 		echo "$matches" | cut -d : -f 1 | while read -r file ; do
	# 			sed -i "" -e "/$key/d" $file
	# 			sed -i "" -e "/$key/d" $keysFile
	# 		done

	# 		break;
	# 	elif [[ $delete =~ ^[n]$ ]]; then
	# 		echo "no delete"
	# 		break;
	# 	fi
	# done
	    
done