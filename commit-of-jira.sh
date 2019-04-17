#!/bin/sh

if [ -z "$1" ]; then
	echo "The first parameter has to be the jira id"
	echo "The second parameter is optional, you can add (not overwrite) another description"
	echo "The third parameter is optional, its the -d option of the hg commit"
	exit 0
fi

description=$(description-for-commit $1)

if [ ! -z "$2" ]; then
	description="$2. $description"
fi

echo "Commit description: $description"

if [ ! -z "$3" ]; then
	hg ci -d "$3" -A -m "$description"
else
	hg ci -A -m "$description"
fi

echo "$1" | tr -d '\n' | pbcopy