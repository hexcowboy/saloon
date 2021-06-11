#!/bin/bash
# The entrypoint for installing all scripts in this directory

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root"
    exit 1
fi

# Recurse over all script directories and run the scripts
for file in /tmp/scripts/install-*.sh
do
    # The interactive mode is used to preserve user $PATH
    bash -i $file | tee -a "/tmp/build.log"
done
