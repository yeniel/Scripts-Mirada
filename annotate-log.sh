#!/bin/sh

fileToAnnotate=$(find . -name $1)
lineToAnnotate="$2p"

annotate=$(hg annotate -ncul $fileToAnnotate | sed -n $lineToAnnotate)
revisionNumber=$(hg annotate -n $fileToAnnotate | sed -n $lineToAnnotate | cut -d ':' -f 1 | sed -e 's/^[[:space:]]*//')
changeset=$(hg annotate -c $fileToAnnotate | sed -n $lineToAnnotate | cut -d ':' -f 1)
lineString=$(hg annotate $fileToAnnotate | sed -n $lineToAnnotate | cut -d ':' -f 2 | sed -e 's/^[[:space:]]*//')
escapedLineString=$(echo "$lineString" | sed -e 's/\./\\\./g' | sed -e 's/(/\\(/g' | sed -e 's/)/\\)/g')

echo "\nANNOTATE LINE\n"
echo $annotate

echo "\n\nCOMMIT\n"
hg log -r $changeset
echo ""

AnnotateParents () {
	parents=$(hg log -r $1 | grep "parent:" | cut -d ":" -f 3)

	if [ ! -z "$parents" ]; then
		while IFS= read -r line ; do
			pathOfFileToAnnotate=$(hg status -A --rev $line | grep "^ .*/$2$" | sed -e 's/^[[:space:]]*//')
			parentChangeset=$(hg annotate -c -r $line $pathOfFileToAnnotate | grep "$lineString" | cut -d ':' -f 1)
			
			if [ ! -z "$parentChangeset" ]; then
				hg log -r $parentChangeset
				AnnotateParents $parentChangeset $2
			fi
		done <<< "$parents"
	fi
}

echo "HISTORY\n"

AnnotateParents $changeset $1




