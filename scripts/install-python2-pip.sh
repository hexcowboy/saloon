#!/bin/bash

DEPS="curl python2"
URL="https://bootstrap.pypa.io/pip/2.7/get-pip.py"

for dependency in $DEPS; do
    if ! [ -x "$(command -v $dependency)" ]; then
        echo "$dependency is required to install python2 pip"
        exit 1
    fi
done

curl -fsSL $URL | python2
