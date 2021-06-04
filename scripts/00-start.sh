#!/bin/bash

# Heirarchy of this directory:
# 00 - Entrypoint script
# 10 - Programming languages
# 20 - Package managers and packages

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Recurse over all script directories and run the scripts
for file in /tmp/scripts/**/*
do
    # The interactive mode is used to preserve user $PATH
    bash -i $file | tee -a "/tmp/build.log"
done
