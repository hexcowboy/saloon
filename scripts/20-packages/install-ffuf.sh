#!/bin/bash
REQ="go git"

# Check requirements
for requirement in $REQ; do
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
