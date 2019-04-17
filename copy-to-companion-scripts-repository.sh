#!/bin/sh

COMPANION_SCRIPTS_REPOSITORY=~/workspace/product-iris-companion-scripts

# MERCURIAL

cp annotate-line.sh $COMPANION_SCRIPTS_REPOSITORY/mercurial/
cp annotate-log.sh $COMPANION_SCRIPTS_REPOSITORY/mercurial/
cp annotate-log-with-grep.sh $COMPANION_SCRIPTS_REPOSITORY/mercurial/
cp co-pu-pu.sh $COMPANION_SCRIPTS_REPOSITORY/mercurial/
cp commit-of-jira.sh $COMPANION_SCRIPTS_REPOSITORY/mercurial/
cp commits-not-merged.sh $COMPANION_SCRIPTS_REPOSITORY/mercurial/
cp description-for-commit-public.sh $COMPANION_SCRIPTS_REPOSITORY/mercurial/description-for-commit.sh
cp hgrc-with-ssh-path-public.sh $COMPANION_SCRIPTS_REPOSITORY/mercurial/hgrc-with-ssh-path.sh
cp local-changes-as-new-branch.sh $COMPANION_SCRIPTS_REPOSITORY/mercurial/local-changes-as-new-branch.sh

# GIT

cp cherry-pick-git.sh $COMPANION_SCRIPTS_REPOSITORY/git/

# COMMON

cp aws-search.sh $COMPANION_SCRIPTS_REPOSITORY/common/
cp jenkins-companion.sh $COMPANION_SCRIPTS_REPOSITORY/common/
cp scp-to-jenkins-companion.sh $COMPANION_SCRIPTS_REPOSITORY/common/
cp unit4-public.sh $COMPANION_SCRIPTS_REPOSITORY/common/unit4.sh

# iOS

cp delete-dead-localizable-strings.sh $COMPANION_SCRIPTS_REPOSITORY/iOS/
cp clean_localizable.swift $COMPANION_SCRIPTS_REPOSITORY/iOS/
cp hg-mv-copying-filepath.sh $COMPANION_SCRIPTS_REPOSITORY/iOS/
cp job-commits-not-merged-default.sh $COMPANION_SCRIPTS_REPOSITORY/iOS/
cp job-commits-not-merged-inspire3.sh $COMPANION_SCRIPTS_REPOSITORY/iOS/
cp update-properties-files.sh $COMPANION_SCRIPTS_REPOSITORY/iOS/

# INSTALL

cp install-companion-scripts-repository.sh $COMPANION_SCRIPTS_REPOSITORY/install-scripts.sh