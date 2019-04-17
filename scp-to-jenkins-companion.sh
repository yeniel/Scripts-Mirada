#!/bin/sh

if [ ! -f ~/.ssh/jenkins-companion-id_rsa ]; then
	echo "You should have the private key ~/.ssh/jenkins-companion-id_rsa to connect to Jenkins-Companion"
	exit 0
fi

if [ -z "$1" ]; then
	echo "The first parameter has to be the file to copy"
	exit 0
fi

if [ -z "$2" ]; then
	echo "The second paremter has to be the file in jenkins-companion"
	echo "E.g. '~/workspace/dev_Update_Properties_Files/update-properties-files.sh'"
	exit 0
fi

scp -i ~/.ssh/jenkins-companion-id_rsa $1 jenkins@172.16.29.24:$2
