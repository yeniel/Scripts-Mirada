#!/bin/sh

if [ -z "$1" ]; then
	echo "The first parameter has to be the jira id"
	echo "The second parameter is optional, you can add (not overwrite) another description"
	exit 0
fi

commit-of-jira $1 "$2"
hg pull --rebase

if [[ $(hg st) ]]; then
	echo "Falló el rebase"
else
	hg push
fi
