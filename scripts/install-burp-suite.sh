#!/bin/bash

DEPS="curl openjdk-8-jre"
URL="https://portswigger.net/burp/releases/download?product=community&version=2021.5.2&type=Linux"

apt-get install -y $DEPS

# Install the Burpsuite jar
curl -fsSL $URL -o burp-installer.sh

# Run the install script
yes "" | bash burp-installer.sh

# Create symlinks
ln -s $(which BurpSuiteCommunity) /usr/local/bin/burp
ln -s $(which BurpSuiteCommunity) /usr/local/bin/burpsuite
