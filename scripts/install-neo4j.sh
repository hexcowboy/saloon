#!/usr/bin/env sh
# https://bloodhound.readthedocs.io/en/latest/installation/linux.html

DEPS="wget"

apt-get install -y $DEPS

# Add the neo4j repository
wget -O - https://debian.neo4j.com/neotechnology.gpg.key | apt-key add -
echo 'deb https://debian.neo4j.com stable 4.0' > /etc/apt/sources.list.d/neo4j.list
apt-get update

# Install neo4j
apt-get install -y neo4j

# Configure neo4j to listen on all addresses
sed -i "s/#dbms\.default_listen_address=0\.0\.0\.0/dbms\.default_listen_address=0\.0\.0\.0/" /etc/neo4j/neo4j.conf

# Set default password to "saloon"
neo4j-admin set-initial-password saloon

# Start neo4j on startup
update-rc.d neo4j defaults
