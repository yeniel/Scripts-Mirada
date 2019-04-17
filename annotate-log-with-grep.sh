#!/bin/sh

if [ -z "$1" ]; then
	echo "The first parameter has to be the file to annotate"
	exit 0
fi

if [ -z "$2" ]; then
	echo "The second parameter has to be the lines to annotate"
	echo "Examples:"
	echo "Annotate line 76: annotate-line AppDelegate.swift 76"
	exit 0
fi

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

grepLog=$(hg grep --diff -f "$escapedLineString" $fileToAnnotate)
grepLogAfterRevisionNumber=$(echo "$grepLog" | sed -n -e "/:$revisionNumber:/,\$p" | sed "/$revisionNumber/d")
ancestorsRevisionNumber=$(echo "$grepLogAfterRevisionNumber" | cut -d ':' -f 2 | sort | uniq)

if [ ! -z "$ancestorsRevisionNumber" ]; then
	echo "HISTORY\n"

	while IFS= read -r line ; do
		ancestorChangeset=$(hg log -r $ancestorsRevisionNumber --template "{node}")
		isAncestor=$(hg log -r "$ancestorChangeset::$changeset" --template "{node}")

		if [ ! -z "$isAncestor" ]; then
			hg log -r $ancestorChangeset
			echo ""
		fi
	done <<< "$ancestorsRevisionNumber"
fi





