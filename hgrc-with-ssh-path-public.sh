#!/bin/sh

USER=""
if [ -z "$1" ]; then
	echo "The first parameter have to be the hgrc file to udpate"
	exit 0
fi

sed -i "" "s/http:\/\/dev.mirada.tv\/hg/ssh:\/\/$USER\/\/srv\/hg\/repos/g" $1