#!/bin/sh

description=$(description-for-commit $1)
echo "Commit description: $description"
hg ci -A -m "$description"

