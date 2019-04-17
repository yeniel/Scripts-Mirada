#!/bin/sh

cd ../dev_Iris_Release

hg up -C -q
hg pull -u

branchProperty="branch="
branches=$(hg branches | cut -f1 -d' ' | sed '/^feature/d' | sed '/^Ultravision/d' | sed '/^Inspire3_mergeLibraries/d' | sed '/^iOS---Release-de-Netflix/d' | sed '/^demo/d' | sed '/^rodolfo_default_test/d' | sed '/^xcuitests_one_branch/d' | sed '/^izzigo_presales/d')
brachesList=$(echo "$branches" | paste -s -d"," -)
branchProperty="$branchProperty$brachesList"

echo $branchProperty

PROJECT_NAME="Iris-ipad.xcodeproj"

while IFS= read -r branch ; do
	echo "Updating to branch $branch"

	hg up -C -q
	hg up $branch -q

	if [ "$branch" = "R3.10.X" ]; then
		PROJECT_PATH="Movistar-sources/Mirada/Movistar/src/Movistar/"
	else
		PROJECT_PATH="Iris/src/"
	fi

	echo "Searching targets in $PROJECT_PATH$PROJECT_NAME"

	targetsOfCurrentBranch=$(xcodebuild -project "$PROJECT_PATH$PROJECT_NAME" -list | sed -n -e '/.*Targets:.*/,/.*Build Configurations:.*/{ /.*Targets:.*$/d; /.*Build Configurations:.*/d; p; }' | tr -d ' ' | sed '/^$/d' | paste -s -d"," -)
	targets="$targets$targetsOfCurrentBranch,"

done <<< "$branches"

targets="${targets:0:${#targets}-1}"
targets=$(echo "$targets" | tr ',' '\n' | sort -u | tr '\n' ',')

targetProperty="target=$targets"

echo $targetProperty

echo "$branchProperty" > "iris_release_parameters.txt"
echo "$targetProperty" >> "iris_release_parameters.txt"

scp iris_release_parameters.txt jenkins@dev-jenkins-mad:/home/jenkins/dev_Iris_Release/iris_release_parameters.txt

rm iris_release_parameters.txt

hg -q up default