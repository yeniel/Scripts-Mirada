#!/bin/sh

#annotate-line AppDelegate-ipad.m 76,78
#annotate-line AppDelegate-ipad.m 76,78p;80

if [ -z "$1" ]; then
	echo "The first parameter has to be the file to annotate"
	exit 0
fi

if [ -z "$2" ]; then
	echo "The second parameter has to be the lines to annotate"
	echo "Examples:"
	echo "Annotate line 76: annotate-line AppDelegate.swift 76"
	echo "Annotate lines 76 to 78: annotate-line AppDelegate.swift 76,78"
	exit 0
fi

fileToAnnotate=$(find . -name $1)
lineToAnnotate="$2p"

echo ""

hg annotate -ncul $fileToAnnotate | sed -n $lineToAnnotate

hg annotate -c $fileToAnnotate | sed -n $lineToAnnotate | cut -d: -f1 | tr -d '\n' | pbcopy

echo ""
