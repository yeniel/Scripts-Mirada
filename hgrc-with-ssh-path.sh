#!/bin/sh

if [ -z "$1" ]; then
	echo "The first parameter have to be the hgrc file to udpate"
	exit 0
fi

sed -i "" "s/http:\/\/dev.mirada.tv\/hg/ssh:\/\/yeniel.landestoy@dev.mirada.tv\/\/srv\/hg\/repos/g" $1