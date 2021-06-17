#!/usr/bin/env sh
# https://linuxize.com/post/how-to-install-pip-on-ubuntu-20.04/

DEPS="curl python2"
URL="https://bootstrap.pypa.io/pip/2.7/get-pip.py"

apt-get install -y $DEPS

# Install using the pypa script
curl -fsSL $URL | python2
