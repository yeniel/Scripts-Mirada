#!/bin/sh

FULL_TIME_END="2016-10-24 00:00"
PART_TIME_START="2016-12-05 00:00"
FULL_TIME_END_ENCODED=$(echo $FULL_TIME_END | sed 's/ /%20/g')
PART_TIME_START_ENCODED=$(echo $PART_TIME_START | sed 's/ /%20/g')
SECONDS_OF_DAY=86400
DATE_FORMAT="%Y-%m-%d"
DATETIME_FORMAT="%Y-%m-%d %H:%M"
TODAY=$(date +$DATE_FORMAT)
PART_TIME_START_DATE=$(date -jf "$DATETIME_FORMAT" "$PART_TIME_START" +$DATE_FORMAT)
FULL_TIME_END_DATE=$(date -jf "$DATETIME_FORMAT" "$FULL_TIME_END" +$DATE_FORMAT)
users=( "yeniel.landestoy" "pedro.cabrera" "ignacio.bonafonte" "javier.salvador" )
PART_TIME_TMP_FILE=~/performance_part_time.tmp
FULL_TIME_TMP_FILE=~/performance_full_time.tmp
USER="yeniel.landestoy"
PASSWORD="cebiel_17"


secondsWithPartTime=$(( ($(date +%s) - $(date -jf "$DATETIME_FORMAT" "$PART_TIME_START" +%s)) ))
daysWithPartTime=$(( $secondsWithPartTime / $SECONDS_OF_DAY ))
fullTimeStart=$(( $(date -jf "$DATETIME_FORMAT" "$FULL_TIME_END" +%s) - $secondsWithPartTime ))
fullTimeStart=$(date -r $fullTimeStart +$DATE_FORMAT)

echo "\nDías trabajados con jornada reducida: $daysWithPartTime"
echo "\nJornada reducida: $PART_TIME_START_DATE - $TODAY"
echo "Jornada completa: $fullTimeStart - $FULL_TIME_END_DATE"

echo "\nJIRA"

for user in "${users[@]}"
do
    echo "\n$user"

    issuesPartTime=$(curl -s -u $USER:$PASSWORD -X GET -H 'Content-Type: application/json' 'https://mirada.atlassian.net/rest/api/2/search?fields=id&jql=(status%20changed%20by%20'"$user"'%20OR%20status%20was%20Resolved%20by%20'"$user"'%20OR%20status%20was%20Done%20by%20'"$user"')%20AND%20updated%20%3E%3D%20%22'"$PART_TIME_START_ENCODED"'%22%20ORDER%20BY%20updated%20DESC' | jq -r '.total')

    echo "\nIssues jornada reducida: $issuesPartTime"


    issuesFullTime=$(curl -s -u $USER:$PASSWORD -X GET -H 'Content-Type: application/json' 'https://mirada.atlassian.net/rest/api/2/search?fields=id&jql=(status%20changed%20by%20'"$user"'%20OR%20status%20was%20Resolved%20by%20'"$user"'%20OR%20status%20was%20Done%20by%20'"$user"')%20AND%20updated%20%3E%3D%20%22'"$fullTimeStart"'%2000%3A00%22%20AND%20updated%20%3C%20%22'"$FULL_TIME_END_ENCODED"'%22%20ORDER%20BY%20updated%20DESC' | jq -r '.total')

    echo "Issues jornada completa: $issuesFullTime"

    if [ "$user" == ${users[0]} ]; then
        performanceVariation=$(echo 'scale=4;(('"$issuesPartTime"' / '"$issuesFullTime"') - 0.75) * 100' | bc)
    else
        performanceVariation=$(echo 'scale=4;(('"$issuesPartTime"' / '"$issuesFullTime"') - 1) * 100' | bc)
    fi

    echo "\nRendimiento: $performanceVariation"
done

echo "\nMERCURIAL"

cd /Users/yeniel.landestoy/workspace/ios/product-iris-mobile
hg churn -d "$PART_TIME_START_DATE to $TODAY" > PART_TIME_TMP_FILE
hg churn -d "$fullTimeStart to $FULL_TIME_END_DATE" > FULL_TIME_TMP_FILE
numberOfUsers=$(wc -l < PART_TIME_TMP_FILE)

for (( row=1; row<=numberOfUsers; row++ ))
do
    echo "\n"
    awk 'FNR == '"$row"' {print $1}' PART_TIME_TMP_FILE

    linesPartTime=$(awk 'FNR == '"$row"' {print $2}' PART_TIME_TMP_FILE)
    linesFullTime=$(awk 'FNR == '"$row"' {print $2}' FULL_TIME_TMP_FILE)

    echo "\nLíneas jornada reducida: $linesPartTime"
    echo "Líneas jornada completa: $linesFullTime"

    if [ "$user" == ${users[0]} ]; then
        performanceVariation=$(echo 'scale=4;(('"$linesPartTime"' / '"$linesFullTime"') - 0.75) * 100' | bc)
    else
        performanceVariation=$(echo 'scale=4;(('"$linesPartTime"' / '"$linesFullTime"') - 1) * 100' | bc)
    fi

    echo "\nRendimiento: $performanceVariation"
done

rm -f PART_TIME_TMP_FILE
rm -f FULL_TIME_TMP_FILE
