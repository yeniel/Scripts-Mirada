#!/bin/sh

chmod +x *

#brew install gcalcli
#./install_gcalcli.sh

path=$(pwd)

ln -sf "$path"/annotate-line.sh /usr/local/bin/annotate-line
ln -sf "$path"/annotate-log-with-grep.sh /usr/local/bin/annotate-log-with-grep
ln -sf "$path"/annotate-log.sh /usr/local/bin/annotate-log
ln -sf "$path"/connect-vpn.sh /usr/local/bin/connect-vpn
ln -sf "$path"/disconnect-vpn.sh /usr/local/bin/disconnect-vpn
ln -sf "$path"/unit4.sh /usr/local/bin/unit4
ln -sf "$path"/description-for-commit.sh /usr/local/bin/description-for-commit
ln -sf "$path"/jira-comment.sh /usr/local/bin/jira-comment
ln -sf "$path"/commit-of-jira.sh /usr/local/bin/commit-of-jira
ln -sf "$path"/commits-not-merged.sh /usr/local/bin/commits-not-merged
ln -sf "$path"/hgrc-with-ssh-path.sh /usr/local/bin/hgrc-with-ssh-path
ln -sf "$path"/jenkins-companion.sh /usr/local/bin/jenkins-companion
ln -sf "$path"/co-pu-pu.sh /usr/local/bin/co-pu-pu
ln -sf "$path"/scp-to-jenkins-companion.sh /usr/local/bin/scp-to-jenkins-companion
ln -sf "$path"/local-changes-as-new-branch.sh /usr/local/bin/local-changes-as-new-branch