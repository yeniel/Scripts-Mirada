#!/bin/sh

brew install jq
brew install curl
# pip install mercurial
#brew install gcalcli
#./install_gcalcli.sh

chmod +x *

path=$(pwd)

ln -sf "$path"/mercurial/annotate-line.sh /usr/local/bin/annotate-line
ln -sf "$path"/mercurial/annotate-log-with-grep.sh /usr/local/bin/annotate-log-with-grep
ln -sf "$path"/mercurial/annotate-log.sh /usr/local/bin/annotate-log
ln -sf "$path"/mercurial/co-pu-pu.sh /usr/local/bin/co-pu-pu
ln -sf "$path"/mercurial/commit-of-jira.sh /usr/local/bin/commit-of-jira
ln -sf "$path"/mercurial/commits-not-merged.sh /usr/local/bin/commits-not-merged
ln -sf "$path"/mercurial/description-for-commit.sh /usr/local/bin/description-for-commit
ln -sf "$path"/mercurial/hgrc-with-ssh-path.sh /usr/local/bin/hgrc-with-ssh-path
ln -sf "$path"/mercurial/local-changes-as-new-branch.sh /usr/local/bin/local-changes-as-new-branch

ln -sf "$path"/common/aws-search.sh /usr/local/bin/aws-search
ln -sf "$path"/common/jenkins-companion.sh /usr/local/bin/jenkins-companion
ln -sf "$path"/common/scp-to-jenkins-companion.sh /usr/local/bin/scp-to-jenkins-companion
ln -sf "$path"/common/unit4.sh /usr/local/bin/unit4
