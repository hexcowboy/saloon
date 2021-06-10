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

ADD manifests /tmp/manifests
# Install apt manifests
RUN xargs apt-get install -y < /tmp/manifests/apt.lib.txt
RUN xargs apt-get install -y < /tmp/manifests/apt.lang.txt
RUN xargs apt-get install -y < /tmp/manifests/apt.txt
# Install python manifests
RUN xargs pip install < /tmp/manifests/pip.txt
# Install ruby manifests
RUN xargs gem install < /tmp/manifests/gems.txt
# Install go manifests
RUN xargs go get < /tmp/manifests/go.txt
# Install rust manifests
# WARNING: these take a really long time to build
# RUN xargs cargo install < /tmp/manifests/crates.txt

# Copy the bashrc to the home directory
ADD config/bashrc /root/.bashrc

WORKDIR $HOME
CMD /bin/bash
