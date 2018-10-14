#!/bin/sh
git commit -am "$3"
git checkout $2
git cherry-pick $1
git pull --rebase
git checkout master
git pull --rebase
