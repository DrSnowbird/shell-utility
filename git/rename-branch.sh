#!/bin/bash -x

OLD=${1:-main}
NEW=${2:-master}
#git branch -m main master
git branch -m ${OLD} ${NEW}
git fetch origin
#git branch -u origin/master master
git branch -u origin/${NEW} ${NEW}
git remote set-head origin -a
