#!/bin/sh

if [ ! -f ~/.ssh/jenkins-companion-id_rsa ]; then
	echo "You should have the private key ~/.ssh/jenkins-companion-id_rsa to connect to Jenkins-Companion"
	exit 0
fi

ssh jenkins@172.16.29.24 -i ~/.ssh/jenkins-companion-id_rsa