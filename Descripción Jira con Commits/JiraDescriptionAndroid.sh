#!/bin/bash 

#------- USER VARS --------

USER_DIRECTORY=
USER_NAME=

#---------------------------

CURRENT_FOLDER=${PWD}
PROJECT_NAME="product-iris-android-inspire"
MERCURIAL_URL="http://dev.mirada.tv/hg"
BY_USER=()

if [[ -z $USER_DIRECTORY ]]; then
    echo "Missing user directory for the project"
    echo "Edit JiraDescriptionAndroid.sh and add a value to USER_DIRECTORY at start of the file"
    exit
fi

if [[ -z $USER_NAME ]]; then
    echo "Missing user name for mercurial"
    echo "Edit JiraDescriptionAndroid.sh and add a value to USER_NAME at start of the file"
    exit
fi

if [[ -z $1 ]]; then
    echo "Missing keyword to search commits"
    echo "Use: JiraDescriptionAndroid.sh JIRA-TAG [-a]"
    echo "By default it only list the commist of the user $USER_NAME. To list all commits use -a parameter."
    exit
fi

if [ "-h" == "$1" ]; then
    echo "Use: JiraDescriptionAndroid.sh JIRA-TAG [-a]"
    echo "By default it only list the commist of the user $USER_NAME. To list all commits use -a parameter."
    exit
fi

if [ "-a" != "$2" ]; then
    BY_USER=(-u "$USER_NAME")
fi

PROJECT_ROOT=$USER_DIRECTORY$PROJECT_NAME

TEMP_FILE=/tmp/commit.jira.tmp

WARNING_COLOR="\033[0;31m"
NC='\033[0m'

cd $PROJECT_ROOT
NAME=`cat .hg/hgrc | grep "hg/repos" | sed -r 's/.*\/hg\/repos\/(.+)/\1/'`
LOG_TEMPLATE="Changeset:\t{node}\n\{noformat}\nModule:\t\t"$NAME"\nBranch:\t\t{branch}\nAuthor:\t\t{author}\nDate:\t\t{date|isodate}\n\{noformat}\n{phase}\n\n"
hg log "${BY_USER[@]}" --keyword $1 --template $LOG_TEMPLATE | sed -r "s#Changeset:\t(............).+#Changeset:\t[\1|$MERCURIAL_URL/$NAME/rev/\1]#" > $TEMP_FILE

for D in $PROJECT_ROOT/*; do 
	if [ -f "${D}/.hg/hgrc" ]; then 
		cd "${D}";
		NAME=`cat .hg/hgrc | grep "hg/repos" | sed -r 's/.*\/hg\/repos\/(.+)/\1/'`
		LOG_TEMPLATE="Changeset:\t{node}\n\{noformat}\nModule:\t\t"$NAME"\nBranch:\t\t{branch}\nAuthor:\t\t{author}\nDate:\t\t{date|isodate}\n\{noformat}\n{phase}\n\n"
		hg log  "${BY_USER[@]}" --keyword $1 --template $LOG_TEMPLATE | sed -r "s#Changeset:\t(............).+#Changeset:\t[\1|$MERCURIAL_URL/$NAME/rev/\1]#" >> $TEMP_FILE
		cd ..
	fi 
done

echo ""

echo "*COMMITS*"

DRAFT="no"
if [ "0" != $(cat $TEMP_FILE | grep -c "draft") ]; then
    echo -e "$WARNING_COLOR---- DRAFT -----"
    cat $TEMP_FILE | grep -B 7 "draft"
    echo "----------------"
    echo -e "$NC"
    DRAFT="yes"
fi

cat $TEMP_FILE | grep -B 7 "public" | sed -r 's/public//' | sed -r 's/--//'

echo ""

echo "*FIX DESCRIPTION*"

cd $PROJECT_ROOT
hg log  "${BY_USER[@]}" --keyword $1 --template '{desc}\n' > $TEMP_FILE

for D in $PROJECT_ROOT/*; do 
	if [ -f "${D}/.hg/hgrc" ]; then
		cd "${D}";
		hg log "${BY_USER[@]}" --keyword $1 --template '{desc}\n' >> $TEMP_FILE
		cd ..
	fi 
done

cat $TEMP_FILE| grep -v $1 | grep -v -e '^[[:space:]]*$' | awk '!x[$0]++'
rm $TEMP_FILE

cd $CURRENT_FOLDER

echo ""

if [ "no" != $DRAFT ]; then
    echo -e "$WARNING_COLOR WARNING Changes not uploaded$NC"
fi
