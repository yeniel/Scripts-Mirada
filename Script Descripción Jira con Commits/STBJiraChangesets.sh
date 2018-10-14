#!/bin/bash

#
# Generate JIRA comments
# with data uploaded to mercurial
#

# Check params
if [ $# -lt 1 ]; then
    echo "usage $0 jira-id"
    exit 1
fi

########################################
# Mercurial data
########################################

MERCURIAL_URL=http://dev.mirada.tv/hg
REVISION_PATH=rev

########################################
# Mercurial templates
########################################

REPOSITORIES="
product-inspire
library-startv
library-modulemanager
library-startv-app-glue
project-inspireGUI
"

JPWD=$(pwd)

for i in $REPOSITORIES; do
    pushd "$JPWD" > /dev/null
    if [ "$i" != "product-inspire" ]; then
        cd "$i"
    fi
    # Template for this repository
    LOG_TEMPLATE="Changeset:[{node}|$MERCURIAL_URL/$i/$REVISION_PATH/{node|short}]\nBranch:{branch}\nAuthor:{author}\nDate:{date|isodate}\n"
    # Read all changesets for this JIRA
    appChangeset=$(hg log --keyword "$1" --template '{node}\n')
    if [ -n "$appChangeset" ]; then
        echo "*$i:*"
        for j in $appChangeset; do
            # For each changeset
            appLog=$(hg log --rev "$j" --template "$LOG_TEMPLATE")
            echo "{panel}"
            echo "$appLog"
            # Take description
            appLog=$(hg log --rev "$j" --template "{desc}")
            if [ -n "$appLog" ]; then
                echo "Description:"
                echo "{noformat}"
                if [[ "$appLog" == $1* ]]; then
                    # Do something here
                    while read -r line; do
                        if [ -n "$line" ]; then
                            if [[ "$line" != $1* ]]; then
                                if [[ "$line" != http*$1* ]]; then
                                    echo "$line"
                                fi
                            fi
                        fi
                    done <<< "$appLog"
                else
                    # Do something here
                    echo "$appLog"
                fi
                echo "{noformat}"
            fi
            echo "{panel}"
        done
    fi
    popd > /dev/null
done
