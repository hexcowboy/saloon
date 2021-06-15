#!/usr/bin/env sh
# https://github.com/openwall/john/blob/bleeding-jumbo/doc/INSTALL-UBUNTU

DEPS="git build-essential libssl-dev zlib1g-dev yasm pkg-config libgmp-dev libpcap-dev libbz2-dev"
URL="https://github.com/openwall/john"
BRANCH="bleeding-jumbo"

apt-get install -y $DEPS

git clone --depth 1 $URL -b $BRANCH /opt/john

(
  cd /opt/john/src;
  ./configure && \
  make -s clean && \
  make -sj4;
)
