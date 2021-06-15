#!/bin/bash

DEPS="openjdk-11-jdk jq unzip curl wget"
URL="https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest"
DEST="/opt/ghidra"

# Install dependencies
apt-get install -y $DEPS

# Use the GitHub API to find latest release
RELEASE=$(curl $URL | jq -r '.assets[].browser_download_url')

# Download the release
wget $RELEASE -O ghidra.zip

# Extract the Zip file
# uses this weird workaround to rename the folder
# https://superuser.com/questions/518347/equivalent-to-tars-strip-components-1-in-unzip
unzip -d "$DEST" "ghidra.zip" && f=("$DEST"/*) && mv "$DEST"/*/* "$DEST" && rmdir "${f[@]}"

# Add to path
ln -s /opt/ghidra/ghidraRun /usr/local/bin/ghidraRun
