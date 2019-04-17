#!/bin/sh

cd ../dev_Iris_Release

hg up -C
hg strip 'roots(outgoing())'
hg pull -u
hg up Inspire3

commits-not-merged R4.1.X

mv email.txt ../dev_Commits_Not_Merged_Inspire3/