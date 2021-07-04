#!/bin/bash

# --- GIT commit and push remote ---
gsave() {
    commit_text="`date`:`git status |grep modified|sed 's/[\t ]*//g'`"
    # commit_text="${1:-commit all changes at } `date`"
    branch=`git branch | grep '*'|awk '{print $2}'`
    git pull origin ${branch:-master}
    git status
    git add -A :/
    echo "commit_text: ${1:-$commit_text}"
    echo "..........."
    git commit -a -m "${1:-$commit_text}"
    git push origin ${branch:-master}
}

gdt() {
  tool=${1:-meld}
  git difftool -y --tool=$tool $1
}

gmt() {
   tool=${1:-meld}
   git mergetool -y --tool=$tool $1
}

alias gconf='git config -e'
alias gst='git status'
alias gadd='git add .'
alias gdif='git diff '

alias glog0='git log --graph --all'
#alias gvlog='git log --graph --full-history --all --simplify-by-decoration --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
alias gvlog1='git log --graph --full-history --all --color --pretty=format:"%x1b[31m%h%x09%x1b[32m%d%x1b[0m%x20%s"'
alias gvlog='git log --graph --pretty=format:"%Cred%h%Creset %ad %s %C(yellow)%d%Creset %C(bold blue)<%an>%Creset" --date=short'
alias gvlogh='git log --graph --full-history --all --pretty=format:"%Cred%h%Creset %ad %s %C(yellow)%d%Creset %C(bold blue)<%an>%Creset" --date=short'
alias gcmt='git commit -a'
alias gpush='git push origin master'
alias gpull='git pull origin master'
alias gb='git branch'

