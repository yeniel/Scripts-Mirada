#!/bin/sh

if [ -z "$1" ]; then
	echo "The first parameter has to be the jira id"
	exit 0
fi

jiraTitle=$(curl -s -u yeniel.landestoy:cebiel_17 "https://mirada.atlassian.net/rest/api/latest/issue/$1" | jq -r ".fields.summary" | tr -d '\n')

commitDescription="$1 $jiraTitle"

echo $commitDescription
echo $commitDescription | tr -d '\n' | pbcopy

