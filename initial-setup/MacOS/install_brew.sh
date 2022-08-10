#!/bin/bash -x


# put your Git mirror of Homebrew/brew here
export HOMEBREW_BREW_GIT_REMOTE="$HOME/.git-brew"

# put your Git mirror of Homebrew/homebrew-core here
export HOMEBREW_CORE_GIT_REMOTE="$HOME/.git-core"

mkdir $HOME/.git-brew
mkdir $HOME/.git-core

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/rsheu/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

echo ">>>> Success: try: brew help"
