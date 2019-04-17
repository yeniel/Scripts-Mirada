#!/bin/sh

USER=""
PASSWORD=""

if [ -z "$1" ]; then
	echo "The first parameter has to be the jira id"
	exit 0
fi

if [ -z "$USER" ]; then
	echo "You should set the user variable inside the script"
	exit 0
fi

if [ -z "$PASSWORD" ]; then
	echo "You should set the password variable inside the script"
	exit 0
fi

jiraTitle=$(curl -s -u $USER:$PASSWORD "https://mirada.atlassian.net/rest/api/latest/issue/$1" | jq -r ".fields.summary" | tr -d '\n')

commitDescription="$1 $jiraTitle"

echo $commitDescription
echo $commitDescription | tr -d '\n' | pbcopy