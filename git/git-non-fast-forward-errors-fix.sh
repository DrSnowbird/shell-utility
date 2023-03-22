#!/bin/bash -x

## ref: https://docs.github.com/en/get-started/using-git/dealing-with-non-fast-forward-errors

if [ $# -lt 1 ]; then
    echo ">>> Please provide 'branch' name: e.g., main, or integration, etc."
    exit 1
fi
# You can simply use git pull to perform both commands at once:
# Grabs online updates and merges them with your local work
git pull origin ${BRANCH_NAME:-main}

# You can fix this by fetching and merging the changes made on the remote branch
#   with the changes that you have made locally:

# 1.) Fetches updates made to an online repository
#git fetch origin

# 2.) Merges updates made online with your local work
#git merge origin ${BRANCH_NAME:-main}

echo ">>> ... done fetching and merging ..."

