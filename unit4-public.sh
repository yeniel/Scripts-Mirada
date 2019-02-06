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

LOG_TEMPLATE='Commit Description:\t'$DESCRIPTION_COLOR'{desc}'$NC
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
        
        SAVEIFS=$IFS
        IFS=$'\n'
        
        jiraIds=($(echo "$jiraDescription" | cut -d ' ' -f 1))
        uniqJiraIds=($(echo "${jiraIds[@]}" | tr ' ' '\n' | sort -u))

        IFS=$SAVEIFS
        
        for jiraId in "${uniqJiraIds[@]}";
        do
            jiraJson=$(curl -s -u $USER:$PASSWORD -X GET -H 'Content-Type: application/json' https://mirada.atlassian.net/rest/api/latest/issue/$jiraId)
            label=$(jq -r ".fields.labels[0]" <<< "$jiraJson")
            workorder=$(jq -r ".fields.customfield_11700" <<< "$jiraJson")
            jiraType=$(jq -r ".fields.issuetype.name" <<< "$jiraJson")
            
            if [ "$jiraType" == "null" ]; then
                continue
            fi

            
            if [ "$jiraType" == "Bug" ] || [ "$jiraType" == "Issue" ]; then
                OUTPUT="$OUTPUT\nUnit4 Description:\t"$DESCRIPTION_COLOR"Bugfixing - iOS - $jiraId"$NC
            elif [ "$jiraType" == "Feature" ] || [ "$jiraType" == "New Feature" ]; then
                OUTPUT="$OUTPUT\nUnit4 Description:\t"$DESCRIPTION_COLOR"Task - iOS - $jiraId"$NC
            else
                OUTPUT="$OUTPUT\nUnit4 Description:\t"$DESCRIPTION_COLOR"$jiraType - iOS - $jiraId"$NC
            fi
            
            if [ $label != "null" ] ; then
                OUTPUT="$OUTPUT\nLabel:\t\t\t"$DESCRIPTION_COLOR"$label"$NC
            fi

            if [ $workorder != "null" ] && [ $workorder != "tbc" ]; then
                OUTPUT="$OUTPUT\nWorkorder:\t\t"$DESCRIPTION_COLOR"$workorder\n"$NC
            fi

            echo ""

        done
    fi
}

# CALENDAR

echo "\n\n${WHITE}CALENDAR${NC}"

startDate=$(date -j -v-"$DAYS"d +"%Y-%m-%d")
endDate=$(date +"%Y-%m-%d")
gcalcli search 'yeniel' $startDate $endDate

# MERCURIAL

echo "\n\n${WHITE}MERCURAL${NC}"

# Project paths

IZZI_IRIS_PATH=~/workspace/ios/product-iris-mobile
IZZI_APP_PATH=$IZZI_IRIS_PATH
IZZI_INTERFACE_PATH=$IZZI_IRIS_PATH/Iris/libraries/library-iris-ios-interface

KIDS_IRIS_PATH=~/workspace/ios/Kids
KIDS_APP_PATH=$KIDS_IRIS_PATH
KIDS_INTERFACE_PATH=$KIDS_IRIS_PATH/Kids/KidsLibrary

for day in $(seq 0 "$DAYS"); do

    echo "\n\n${DAY_COLOR}$(date -j -v-"$day"d +"%A %d")${NC}";

    startDate=$(date -j -v-"$day"d +"%Y-%m-%d 00:00:00")
    endDate=$(date -j -v-"$day"d +"%Y-%m-%d 23:59:59")

    # Izzi

    echo "\n\n${WHITE}Izzi${NC}"

    RepositoryLog $IZZI_APP_PATH APP
    RepositoryLog $IZZI_INTERFACE_PATH INTERFACE

    echo "$OUTPUT"
    OUTPUT=""

    # Kids

    echo "\n\n${WHITE}Kids${NS}"

    RepositoryLog $KIDS_APP_PATH APP
    RepositoryLog $KIDS_INTERFACE_PATH INTERFACE

    echo "$OUTPUT"
    OUTPUT=""

done

