#!/bin/bash

#set -eo pipefail

WORKDIR=$HOME/Git
GITLAB_USER=git
GITLAB_DOMAIN=gitlab.com
GITLAB_GROUP=alex_malder
remotes=("gitlab" "origin") # origin is github

push_repo() {
    echo "$WORKDIR/$1"
    git -C $WORKDIR/$1 remote add gitlab $GITLAB_USER@$GITLAB_DOMAIN:$GITLAB_GROUP/$1
    for remote in $remotes; do
        git -C $WORKDIR/$1 push -u $remote master
    done
}

for repository in $(ls $WORKDIR); do
    push_repo $repository &
done
