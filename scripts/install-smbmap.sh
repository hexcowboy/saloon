#!/usr/bin/env sh
# https://github.com/ShawnDEvans/smbmap

DEPS="wget python3"
URL="https://raw.githubusercontent.com/ShawnDEvans/smbmap/master/smbmap.py"
PIP_REQS="https://raw.githubusercontent.com/ShawnDEvans/smbmap/master/requirements.txt"

apt-get install -y $DEPS

# Install python3 dependencies
curl $PIP_REQS | pip3 install -r

# Install SMBMap as a binary
wget $URL -O /usr/local/bin/smbmap.py
chmod +x /usr/local/bin/smbmap.py
