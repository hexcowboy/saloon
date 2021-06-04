#!/bin/bash
REQS="go git"

# Check requirements
for requirement in $REQS; do
    if ! [ -x "$(command -v $requirement)" ]; then
        echo "$requirement is required to install ffuf"
        exit 1
    fi
done

# Install ffuf
go get -u github.com/ffuf/ffuf
