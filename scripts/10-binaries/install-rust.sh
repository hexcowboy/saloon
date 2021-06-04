#!/bin/bash
RUST_DEPS="curl"

# Install dependencies
for dependency in $RUST_DEPS; do
    apt-get update && apt-get install -y curl
done

# The install script adds to our bashrc, so add a newline first
echo "" >> $HOME/.bashrc
echo "# Add Rust to the path" >> $HOME/.bashrc

# Run the install script
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

# Add Rust to the PATH
echo "export PATH=\$HOME/.cargo/bin:\$PATH" >> $HOME/.bashrc
