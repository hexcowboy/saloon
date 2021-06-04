FROM docker.io/ubuntu:focal

ENV HOME /root
ENV DEBIAN_FRONTEND noninteractive

# Update repository sources and upgrade packages
RUN apt-get update

# Install Ubuntu sources
RUN apt-get install --fix-missing --assume-yes \
        ubuntu-minimal \
        ubuntu-standard \
        ubuntu-server

# Hotfix for issue with command-not-found
# https://github.com/pwndbg/pwndbg/issues/745
RUN apt-get purge -y command-not-found \
    && apt-get update \
    && apt-get full-upgrade -y \
    && apt-get autoremove -y \
    && apt-get clean

RUN apt-get install -y wget gnupg

# Add install scripts and run them all
ADD scripts /tmp/scripts
RUN bash /tmp/scripts/00-start.sh

WORKDIR $HOME
CMD /bin/bash
