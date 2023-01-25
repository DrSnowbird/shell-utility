#!/bin/bash

if [ $# -lt 1 ]; then
    echo -e ">>> Usage: $0 <git_local_dir_path> <remote_gir_SSH_git_url>"
    echo -e ">>>"
    echo -e ">>> ERROR: you need provide your git URL, e.g.,"
    echo -e "    git@github.com:DrSnowbird/UCO-app-docker.git"
    echo -e
    echo -e "WARNING:"
    echo -e "    Back up all your git files first (you can exclude .git folder)"
    exit 1
fi

# ref: https://www.willandskill.se/en/articles/deleting-your-git-commit-history-without-removing-repo-on-github-bitbucket

## -- Step 1
## -- Remove all history
cd $1
if [ ! -s .git ]; then
    echo -e ">>> ERROR: not a GIT local folder! Abort!"
    exit 1
fi
rm -rf .git

## -- Step 2
## -- Init a new repo
git init
git add .
git commit -m "Removed history, due to sensitive data"

## -- Step 3
## -- Push to remote
git remote add origin $2
git push -u --force origin master
