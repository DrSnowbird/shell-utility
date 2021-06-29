#!/bin/bash -x

# -- implement the following GIT commands to change to new Branch Name --
# git branch -m main master
# git fetch origin
# git branch -u origin/master master
# git remote set-head origin -a

OLD=${1:-main}
NEW=${2:-master}

git branch -m ${OLD} ${NEW}
git fetch origin
git branch -u origin/${NEW} ${NEW}
git remote set-head origin -a
