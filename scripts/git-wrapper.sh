#!/bin/bash

#set -eo pipefail

WORKDIR=$HOME/Git
GITLAB_USER=git
GITLAB_DOMAIN=gitlab.com
GITLAB_GROUP=alex_malder

for repository in $(ls $WORKDIR); do
    echo "$WORKDIR/$repository"
    git -C $WORKDIR/$repository remote add gitlab $GITLAB_USER@$GITLAB_DOMAIN:$GITLAB_GROUP/$repository
    git -C $WORKDIR/$repository push -u gitlab master
    git -C $WORKDIR/$repository push -u origin master
done
