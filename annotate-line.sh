#!/bin/sh

#annotate-line AppDelegate-ipad.m 76,78
#annotate-line AppDelegate-ipad.m 76,78p;80

fileToAnnotate=$(find . -name $1)
lineToAnnotate="$2p"

echo ""

hg annotate -ncul $fileToAnnotate | sed -n $lineToAnnotate

echo ""
