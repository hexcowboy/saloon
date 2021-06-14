#!/bin/bash
# https://github.com/hexcowboy/docker-burp-suite-community/blob/master/Dockerfile

DEPS="curl default-jre openssl ca-certificates libxext6 libxrender1 libxtst6"
URL="https://portswigger.net/burp/releases/download"
JAR_FILE="/usr/local/BurpSuiteCommunity/burpsuite_community.jar"
BIN_FILE="/usr/local/bin/BurpSuiteCommunity"

apt-get install -y $DEPS

# Download the Burpsuite jar
mkdir -p $(dirname $JAR_FILE)
curl -fsSL $URL -o $JAR_FILE

# Create a binary
cat << EOF > $BIN_FILE
#!/usr/bin/env sh

PROJECT_CONFIG="/etc/burpsuite/project_options.json"
USER_CONFIG="/etc/burpsuite/user_options.json"

set -e

exec java -jar "$JAR_FILE" --config-file="\$PROJECT_CONFIG" --user-config-file="\$USER_CONFIG"
EOF

chmod u+x $BIN_FILE

# Create symlinks
ln -s $BIN_FILE /usr/local/bin/burp
ln -s $BIN_FILE /usr/local/bin/burpsuite
