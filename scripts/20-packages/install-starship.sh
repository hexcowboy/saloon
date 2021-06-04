#!/bin/bash

REQS="curl"

for requirement in $REQS; do
    if ! [ -x "$(command -v $requirement)" ]; then
        echo "$requirement is required to install starship prompt"
        exit 1
    fi
done

# Install from bash script
# https://starship.rs/guide/#%F0%9F%9A%80-installation
curl -fsSL https://starship.rs/install.sh | bash -s -- --yes

# Add starship to bashrc
echo "" >> $HOME/.bashrc
echo "# Use starship prompt" >> $HOME/.bashrc
echo 'eval "$(starship init bash)"' >> $HOME/.bashrc
