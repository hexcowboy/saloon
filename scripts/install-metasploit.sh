#!/bin/bash
# https://github.com/rapid7/metasploit-framework/wiki/Nightly-Installers

DEPS="curl gnupg"
URL="https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb"

apt-get install -y $DEPS

curl $URL | bash
