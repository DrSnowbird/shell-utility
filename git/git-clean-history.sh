#!/bin/bash -x

# -- ref: https://gist.github.com/stephenhardy/5470814

echo "--- Usage: $0 <GIT_REPO_URL>"
echo "e.g."
echo "  $0 git@github.com:DrSnowbird/json-server-docker.git "
echo

if [ $# -lt 1 ]; then
    echo "*** ERROR: need to provide, at least, GIT Repo name (without .git)"
    exit 1
fi
GIT_REPO_URL=${1}


# -- Remove the history from
rm -rf .git

# -- recreate the repos from the current content only
git init

git add .

# git commit -m "Initial commit"
git commit -S -m "Initial commit" --allow-empty

git remote rm origin

# -- push to the github remote repos ensuring you overwrite history
#git remote add origin git@github.com:DrSnowbird/json-server-docker.git
git remote add origin ${GIT_REPO_URL}

git push -u --force origin master
