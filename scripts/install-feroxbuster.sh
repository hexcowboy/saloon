#!/usr/bin/env sh
# https://github.com/epi052/feroxbuster#download-a-release

DEPS="curl"

apt-get install -y $DEPS

# Install using install script
curl -sL https://raw.githubusercontent.com/epi052/feroxbuster/master/install-nix.sh | bash
