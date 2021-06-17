#!/bin/bash
# The entrypoint for installing all scripts in this directory

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Recurse over all script directories and run the scripts
set -m
for file in /tmp/scripts/installers/*.sh
do
    bash $file | tee -a "/tmp/build.log"
done
