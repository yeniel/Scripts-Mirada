#!/bin/sh

if [[ -z $1 && -z $2 ]]; then
	echo "Missing keyword to search commits"
	exit
fi

################################
# URLS MERCURIAL WEB INTERFACES
################################

MERCURIAL_URL=http://dev.mirada.tv/hg
APP_URL=$MERCURIAL_URL/product-iris-mobile
COMPONENTS_URL=$MERCURIAL_URL/library-iris-ios-components
INTERFACE_URL=$MERCURIAL_URL/library-iris-ios-interface
REVISION_PATH=rev

########################
# LOCAL MERCURIAL PATHS
########################

INSPIRE_PATH=~/workspace/ios/product-iris-mobile
APP_PATH=$INSPIRE_PATH
COMPONENTS_PATH=$INSPIRE_PATH/Movistar-sources/Mirada/libraries/library-iris-ios-components
INTERFACE_PATH=$INSPIRE_PATH/Movistar-sources/Mirada/libraries/library-iris-ios-components/lib/library-iris-ios-interface

#####################
# MERCURIAL TEMPLATE
#####################

LOG_TEMPLATE='\{panel:bgColor=#E6FFE6|borderStyle=solid}\nChangeset:\t{node}\nBranch:\t\t{branches}\nAuthor:\t\t{author}\nDate:\t\t{date|isodate}\nDescription:\t{desc}\n\{panel}'

#####################
# FUNCTIONS
#####################


# Function that return the repository log template
# param $1: Keyword
# param $2: Repository path
# param $3: Repository name
# param $4: Repository url

RepositoryLog () {
    cd $2
    log=$(hg log --keyword $1 --template "\n\n$LOG_TEMPLATE\n$4/{node}")

    if [[ $? != 0 ]]; then
        echo "hg log failed"
        exit
    elif [[ $log ]]; then
        OUTPUT="$OUTPUT\n\nh6. $3"
        OUTPUT="$OUTPUT$log"
    fi
}



#####################
# SCRIPT
#####################


# OUTPUT:	Global output of the script
# appLog:	Log of all commit of the jira id passed as parameter
# appChangeset: List of changesets to create the urls to mercurial web interface

OUTPUT="h6. SHORT DESCRIPTION\n\n$2"

# APP
RepositoryLog $1 $APP_PATH APP $APP_URL/$REVISION_PATH

# COMPONENTS
RepositoryLog $1 $COMPONENTS_PATH COMPONENTS $COMPONENTS_URL/$REVISION_PATH

# INTERFACE
RepositoryLog $1 $INTERFACE_PATH INTERFACE $INTERFACE_URL/$REVISION_PATH


echo "$OUTPUT"
