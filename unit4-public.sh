#!/bin/sh

DESCRIPTION_COLOR="\033[0;31m"
DAY_COLOR="\033[0;34m"
NC="\033[0m"
WHITE="\033[1;37m"
USER=""
PASSWORD=""

DAYS=$1
if [[ -z $1 ]]; then
    DAYS=$(( $(date '+%u') - 1 ))
fi

LOG_TEMPLATE='Description:\t'$DESCRIPTION_COLOR'{desc}'$NC
OUTPUT=""

RepositoryLog () {
    cd $1

    log=$(hg log -r "author('$USER') and date('$startDate to $endDate')" --template "$LOG_TEMPLATE\n\n")

    if [[ $? != 0 ]]; then
        echo "hg log failed"
        exit
    elif [[ $log ]]; then
        OUTPUT="$OUTPUT\n\n$2\n"
        OUTPUT="$OUTPUT\n$log\n\n"

        jiraDescription=$(hg log -r "author('$USER') and date('$startDate to $endDate')" --template "{desc}\n")
        jiraIds=($(echo "$jiraDescription" | cut -d ' ' -f 1))

        for jiraId in "${jiraIds[@]}";
        do
            label=$(curl -s -u $USER:$PASSWORD -X GET -H 'Content-Type: application/json' https://mirada.atlassian.net/rest/api/latest/issue/$jiraId | jq -r ".fields.labels[0]")
            workorder=$(curl -s -u $USER:$PASSWORD -X GET -H 'Content-Type: application/json' https://mirada.atlassian.net/rest/api/latest/issue/$jiraId | jq -r ".fields.customfield_11700")

            if [ $label != "null" ] || [ $workorder != "null" ] ; then
                OUTPUT="$OUTPUT\nJira Id:\t"$DESCRIPTION_COLOR"$jiraId"$NC
            fi

            if [ $label != "null" ] ; then
                OUTPUT="$OUTPUT\nLabel:\t\t"$DESCRIPTION_COLOR"$label"$NC
            fi

            if [ $workorder != "null" ] ; then
                OUTPUT="$OUTPUT\nWorkorder\t"$DESCRIPTION_COLOR"$workorder\n"$NC
            fi
        done
    fi
}

# CALENDAR

echo "\n\n${WHITE}CALENDAR${NC}"

startDate=$(date -j -v-"$DAYS"d +"%Y-%m-%d")
endDate=$(date +"%Y-%m-%d")
gcalcli search 'yeniel' $startDate $endDate
echo "Label: 10111"

# MERCURIAL

echo "\n\n${WHITE}MERCURAL${NC}"

# Project paths

IZZI_INSPIRE_PATH=~/workspace/ios/product-iris-mobile
IZZI_APP_PATH=$IZZI_INSPIRE_PATH
IZZI_COMPONENTS_PATH=$IZZI_INSPIRE_PATH/Movistar-sources/Mirada/libraries/library-iris-ios-components
IZZI_INTERFACE_PATH=$IZZI_INSPIRE_PATH/Movistar-sources/Mirada/libraries/library-iris-ios-components/lib/library-iris-ios-interface

KIDS_INSPIRE_PATH=~/workspace/ios/Kids
KIDS_APP_PATH=$KIDS_INSPIRE_PATH
KIDS_INTERFACE_PATH=$KIDS_INSPIRE_PATH/Kids/KidsLibrary

for day in $(seq 0 "$DAYS"); do

    echo "\n\n${DAY_COLOR}$(date -j -v-"$day"d +"%A %d")${NC}";

    startDate=$(date -j -v-"$day"d +"%Y-%m-%d 00:00:00")
    endDate=$(date -j -v-"$day"d +"%Y-%m-%d 23:59:59")

    # Izzi

    echo "\n\n${WHITE}Izzi${NC}"

    RepositoryLog $IZZI_APP_PATH APP
    RepositoryLog $IZZI_COMPONENTS_PATH COMPONENTS
    RepositoryLog $IZZI_INTERFACE_PATH INTERFACE

    echo "$OUTPUT"
    OUTPUT=""

    # Kids

    echo "\n\n${WHITE}Kids${NS}"

    RepositoryLog $KIDS_APP_PATH APP
    RepositoryLog $KIDS_INTERFACE_PATH INTERFACE

    echo "$OUTPUT"
    OUTPUT=""

    if [[ -z $1 ]]; then
        read -p "Siguiente..." next
    fi
done

