#!/bin/bash

# Heirarchy of this directory:
# 00 - Entrypoint script
# 10 - Programming languages
# 20 - Package managers and packages

DEPS="git build-essential"

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Install dependencies
for dependency in $DEPS; do
    apt-get update && apt-get install -y $dependency
done

# Recurse over all script directories and run the scripts
for file in /tmp/scripts/**/*
do
    # The interactive mode is used to preserve user $PATH
    bash -i $file
done
