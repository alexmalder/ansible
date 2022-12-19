#!/bin/bash

#set -eo pipefail

WORKDIR=$HOME/Git
GITLAB_USER=git
GITLAB_DOMAIN=gitlab.com
GITLAB_GROUP=alex_malder
remotes=("gitlab" "origin") # origin is github

for repository in $(ls $WORKDIR); do
    echo "$WORKDIR/$repository"
    git -C $WORKDIR/$repository remote add gitlab $GITLAB_USER@$GITLAB_DOMAIN:$GITLAB_GROUP/$repository
    for remote in $remotes; do
        git -C $WORKDIR/$repository push -u $remote master
    done
done
