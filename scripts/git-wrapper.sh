#!/bin/bash

#set -eo pipefail

WORKDIR=$HOME/git
NEW_REMOTE_DOMAIN=http://git.vnmntn.com
NEW_REMOTE_GROUP=alexmalder
remotes=("gitea" "origin") # origin is github

for repository in $(ls $WORKDIR); do
    git -C $WORKDIR/$repository remote add gitea $NEW_REMOTE_DOMAIN/$NEW_REMOTE_GROUP/$repository > /dev/null 2>&1
    #echo ""
    #echo "REPOSITORY: [ $repository ]  "
    #echo ""
    for remote in "${remotes[@]}"; do
        #echo "git -C $repository push -u $remote master"
        git -C $WORKDIR/$repository push -u $remote master #> /dev/null 2>&1
    done
    git -C $WORKDIR/$repository log -1 --oneline
done
