#!/bin/bash

DEPS="curl python2"
URL="https://bootstrap.pypa.io/pip/2.7/get-pip.py"

apt-get install -y $DEPS

curl -fsSL $URL | python2
