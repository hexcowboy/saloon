#!/bin/bash
REQS="go git"

# Check requirements
for requirement in $REQS; do
    if ! [ -x "$(command -v $requirement)" ]; then
        echo "$requirement is required to install ffuf"
        exit 1
    fi
done

# Clone repository
git clone --depth 1 https://github.com/ffuf/ffuf.git /opt/ffuf

# Install ffuf
cd /opt/ffuf
go get
go build
