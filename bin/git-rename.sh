#!/bin/bash

if [ -z $2 ]; then
    echo "Usage: $0 old_branch new_branch"
    exit
fi

old_branch=$1
new_branch=$2
git branch -m $old_branch $new_branch
git push origin :$old_branch
git push --set-upstream origin $new_branch

