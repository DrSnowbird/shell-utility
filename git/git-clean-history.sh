#!/bin/bash -x

-- ref: https://gist.github.com/stephenhardy/5470814

echo "--- Usage: <GIT_REPO> [<GIT_USER>]"
echo "e.g."
echo "  for git@github.com:DrSnowbird/json-server-docker.git full GIT Repo:"
echo "  GIT_REPO: json-server-docker"
echo "  GIT_USER: DrSnowbird"
echo

if [ $# -lt 1 ]; then
    echo "*** ERROR: need to provide, at least, GIT Repo name (without .git)"
    exit 1
fi

-- Remove the history from
rm -rf .git

-- recreate the repos from the current content only
git init
git add .
git commit -m "Initial commit"

-- push to the github remote repos ensuring you overwrite history
#git remote add origin git@github.com:DrSnowbird/json-server-docker.git
git remote add origin git@github.com:${GIT_USER}/${GIT_REPO}.git

git push -u --force origin master
