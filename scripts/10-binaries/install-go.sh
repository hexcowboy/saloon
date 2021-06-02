#!/bin/bash
GO_DEPS="wget"
GO_URL="https://golang.org/dl/go1.16.4.linux-amd64.tar.gz"

# Install dependencies
for dependency in $GO_DEPS; do
    apt-get update && apt-get install -y $dependency
done

# Download the tarball
wget -qL $GO_URL -O /tmp/go.tar.gz

# Unzip the tarball
rm -rf /usr/local/go && tar -C /usr/local -xzf /tmp/go.tar.gz

# Add Go to the path
echo "export PATH=\$PATH:/usr/local/go/bin" >> $HOME/.bashrc
