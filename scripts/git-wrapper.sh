#!/bin/bash

#set -eo pipefail

WORKDIR=$HOME/Git
GITLAB_USER=git
GITLAB_DOMAIN=gitlab.com
GITLAB_GROUP=alex_malder
remotes=("gitlab" "origin") # origin is github

for repository in $(ls $WORKDIR); do
    #git -C $WORKDIR/$repository remote add gitlab $GITLAB_USER@$GITLAB_DOMAIN:$GITLAB_GROUP/$repository > /dev/null 2>&1
    #echo ""
    #echo "REPOSITORY: [ $repository ]  "
    #echo ""
    git -C $WORKDIR/$repository log -1
    for remote in "${remotes[@]}"; do
        #echo "git -C $repository push -u $remote master"
        #git -C $WORKDIR/$repository push -u $remote master > /dev/null 2>&1
        echo ""
    done
done
