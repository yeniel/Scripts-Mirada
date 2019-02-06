#!/bin/sh

cd ../dev_Iris_Release

hg pull -u

branchProperty="branch="
branches=$(hg branches | cut -f1 -d' ' | paste -s -d"," -)
branchProperty="$branchProperty$branches"

targetProperty="target="
targets=$(xcodebuild -project Iris/src/Iris-ipad.xcodeproj -list | sed -n -e '/.*Targets:.*/,/.*Build Configurations:.*/{ /.*Targets:.*$/d; /.*Build Configurations:.*/d; p; }' | tr -d ' ' | sed '/^$/d' | paste -s -d"," -)
targetProperty="$targetProperty$targets"

echo "$branchProperty" > "iris_release_parameters.txt"
echo "$targetProperty" >> "iris_release_parameters.txt"

scp -q iris_release_parameters.txt jenkins@dev-jenkins-mad:/home/jenkins/dev_Iris_Release/iris_release_parameters.txt

rm iris_release_parameters.txt