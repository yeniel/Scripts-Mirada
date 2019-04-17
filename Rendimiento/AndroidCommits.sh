#!/bin/sh

INSPIRE_PATH=~/workspace/android/product-iris-android-inspire
APP_PATH=$INSPIRE_PATH/app
COMPONENTS_PATH=$INSPIRE_PATH/components
INTERFACE_PATH=$INSPIRE_PATH/interface

LOG_TEMPLATE='{date|isodate}\n'

OUTPUT=""

cd $INSPIRE_PATH

#date -j -f '%Y-%m-%dT %H:%M:%S %z' "2006-09-04 15:13:13 -0700" +'%H:%m'

#inspireLog=$(hg log --user "yeniel.landestoy@mirada.tv" --template $LOG_TEMPLATE)
inspireLog=$(hg log --template $LOG_TEMPLATE)

if [[ $? != 0 ]]; then
	echo "Inspire hg log failed"
	exit
elif [[ $inspireLog ]]; then
	for commit in "$inspireLog"
	do
		while read -r commit; do
			OUTPUT="$OUTPUT\n"
			OUTPUT=$OUTPUT$(date -j -f "%Y-%m-%dT %H:%M:%S %z" "$commit" +"%H:%m")
    		done <<< "$inspireLog"
	done
fi

cd $APP_PATH

#appLog=$(hg log --user "yeniel.landestoy@mirada.tv" --template $LOG_TEMPLATE)
appLog=$(hg log --template $LOG_TEMPLATE)

if [[ $? != 0 ]]; then
	echo "App hg log failed"
	exit
elif [[ $appLog ]]; then
	for commit in "$appLog"
	do
		while read -r commit; do
			OUTPUT="$OUTPUT\n"
			OUTPUT=$OUTPUT$(date -j -f "%Y-%m-%dT %H:%M:%S %z" "$commit" +"%H:%m")
    		done <<< "$appLog"
	done
fi


cd $COMPONENTS_PATH

#componentsLog=$(hg log --user "yeniel.landestoy@mirada.tv" --template $LOG_TEMPLATE)
componentsLog=$(hg log --template $LOG_TEMPLATE)

if [[ $? != 0 ]]; then
	echo "Components hg log failed"
	exit
elif [[ $componentsLog ]]; then
	for commit in "$componentsLog"
	do
		while read -r commit; do
			OUTPUT="$OUTPUT\n"
			OUTPUT=$OUTPUT$(date -j -f "%Y-%m-%dT %H:%M:%S %z" "$commit" +"%H:%m")
    		done <<< "$componentsLog"
	done
fi


cd $INTERFACE_PATH

#interfaceLog=$(hg log --user "yeniel.landestoy@mirada.tv" --template $LOG_TEMPLATE)
interfaceLog=$(hg log --template $LOG_TEMPLATE)

if [[ $? != 0 ]]; then
	echo "Interface hg log failed"
	exit
elif [[ $interfaceLog ]]; then
	for commit in "$nterfaceLog"
	do
		while read -r commit; do
			OUTPUT="$OUTPUT\n"
			OUTPUT=$OUTPUT$(date -j -f "%Y-%m-%dT %H:%M:%S %z" "$commit" +"%H:%m")
    		done <<< "$interfaceLog"
	done
fi


echo "$OUTPUT"
