#!/bin/sh

cd ../dev_Iris_Release

hg up -C
hg strip 'roots(outgoing())'
hg pull -u
hg up default

commits-not-merged R3.11.X

mv email.txt ../dev_Commits_Not_Merged_Default/
