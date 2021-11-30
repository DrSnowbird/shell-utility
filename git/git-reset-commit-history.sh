#!/bin/bash -x

#If you are sure you want to remove all commit history, simply delete the .git directory in your project root (note that it's hidden). Then initialize a new repository in the same folder and link it to the GitHub repository:

if [ ! -s .git ]; then
    echo "*** Not GIT local repo directory! Abort!"
    exit 1
fi

gitURL=$(cat .git/config |grep "git@"|awk '{print $3}')

commit_text="`date`:`git status |grep modified|sed 's/[\t ]*//g'`"
# commit_text="${1:-commit all changes at } `date`"
branch=`git branch | grep '*'|awk '{print $2}'`
#git pull origin ${branch:-master}
#git status

rm -rf .git

git init
git remote add origin ${gitURL}

#now commit your current version of code
MESSAGE="reset git history logs"
git add *
if [ -s .gitignore ]; then
    git add .gitignore
fi
if [ -s .env ]; then
    git add .env*
fi

git commit -am "${MESSAGE}"

#and finally force the update to GitHub:
git push -f origin ${branch}
git status
