#!/bin/sh

if [ -z "$1" ]; then
	echo "The first parameter has to be the branch to check commits not merged"
	exit 0
fi

hg -q pull --rev $1

currentBranch=$(hg branch)
headOfBranchToMerge=$(hg log -b $1 --limit 1 --template "{node}")
changesetNotMerged=$(hg merge -P $headOfBranchToMerge | grep "changeset:" | cut -f3 -d: | tr '\n' '+' | sed 's/.$//g')
repositoryName=$(pwd | xargs basename)

commitsNotMerged=$(hg log -r $changesetNotMerged --template "Changeset:\t{node}|Author:\t\t{author}|Date:\t\t{date|date}|Description:\t\t{desc}||")
blameRanking=$(hg log -r $changesetNotMerged --template "{author}\n" | sort | uniq -c | sort -nr)

echo "\nBLAME RANKING\n"
echo "$blameRanking"
echo "\nCOMMITS\n"
hg log -r $changesetNotMerged --template "Changeset:\t{node}\nAuthor:\t\t{author}\nDate:\t\t{date|date}\nDescription:\t{desc}\n\n"

if [ "$2" = "-j" ]; then
	cp /dev/null email.txt

	echo "RECIPIENTS=apple-dev@mirada.tv" >> email.txt
	echo "SUBJECT=Repositorio $repositoryName. Commits de $1 no mergeados en $currentBranch" >> email.txt

	if [ -z "$changesetNotMerged" -o ! -n "$changesetNotMerged" ]; then
	  emailText="TEXT=|TODO MERGEADO"
	else
	  blameRanking=$(echo "$blameRanking" | tr -d '\n' | sed -e 's/   /|/g')

	  emailText="TEXT=|BLAME RANKING"
	  emailText="$emailText|$blameRanking"
	  emailText="$emailText||COMMITS|"
	  emailText="$emailText|$commitsNotMerged"
	fi

	echo "$emailText" >> email.txt
fi
