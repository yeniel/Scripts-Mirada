#!/bin/sh

hg pull --rev $1

lastMergeChangeset=$(hg log --rev "reverse(merge() and branch($1) and children(branch($2)))" --limit 1 --template "{node}")
lastCommit=$(hg log -b $2 --limit 1 --template "{node}")

commitNotMerged=$(hg log --rev "$lastCommit % $lastMergeChangeset" --template "Changeset:\t{node}|Author:\t\t{author}|Date:\t\t{date|date}|Description:\t\t{desc}||")

blameRanking=$(hg log --rev "$lastCommit % $lastMergeChangeset" --template "{author}\n" | sort | uniq -c | sort -nr | tr -d '\n' | sed -e 's/   /|/g')

cp /dev/null email.txt

echo "RECIPIENTS=apple-dev@mirada.tv" >> email.txt
echo "SUBJECT=Commits de $2 no mergeados en $1" >> email.txt

if [ -z "$commitNotMerged" -o ! -n "$commitNotMerged" ]; then
  emailText="TEXT=|TODO MERGEADO, QUE PUTOS CRACKS!"
else
  emailText="TEXT=|BLAME RANKING"
  emailText="$emailText|$blameRanking"
  emailText="$emailText||COMMITS|"
  emailText="$emailText|$commitNotMerged"
fi

echo "$emailText" >> email.txt
