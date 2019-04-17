#!/bin/sh

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "\nParameters\n"
	echo "The first parameter has to be description of the local changes commit"
	echo "The second parameter has to be name of the new branch\n"
	exit 0
fi

hg ci -m "$1"

changesetLocalChanges=$(hg log -r 'limit(reverse(all()),1)' | head -n 1 | cut -d: -f3)

hg up -r $newCommit
hg branch $2
hg ci -m "New branch $2"
changesetNewBranch=$(hg log -r 'limit(reverse(all()),1)' | head -n 1 | cut -d: -f3)

hg rebase -s $changesetLocalChanges -d $changesetNewBranch