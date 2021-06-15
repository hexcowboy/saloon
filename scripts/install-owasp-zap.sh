#!/usr/bin/env sh
# https://software.opensuse.org/download.html?project=home%3Acabelo&package=owasp-zap

DEPS="curl gnupg"
SOURCE="http://download.opensuse.org/repositories/home:/cabelo/xUbuntu_20.04/"
KEY="https://download.opensuse.org/repositories/home:cabelo/xUbuntu_20.04/Release.key"

apt-get install -y $DEPS

# Add sources to container
echo "deb $SOURCE /" | tee /etc/apt/sources.list.d/home:cabelo.list

# Add GPG keys to container
curl -fsSL "$KEY" | gpg --dearmor | tee /etc/apt/trusted.gpg.d/home_cabelo.gpg > /dev/null

# Install OWASP ZAP
apt-get update
apt-get install -y owasp-zap
