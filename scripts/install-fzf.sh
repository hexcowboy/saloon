#!/usr/bin/env sh
# https://github.com/junegunn/fzf#using-git

DEPS="git"

apt-get install -y $DEPS

# Clone repo
git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.fzf

# Run installer
$HOME/.fzf/install
