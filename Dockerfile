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

# Workaround for command-not-found bug
# https://github.com/pwndbg/pwndbg/issues/745
RUN apt-get purge -y command-not-found \
    && apt-get --purge -y autoremove \
    && apt-get update \
    && apt-get full-upgrade -y \
    && apt-get autoremove \
    && apt-get clean

ADD manifests /tmp/manifests
# Install apt manifests
RUN xargs apt-get install -y < /tmp/manifests/apt.lib.txt
RUN xargs apt-get install -y < /tmp/manifests/apt.lang.txt
RUN xargs apt-get install -y < /tmp/manifests/apt.txt
# Install python manifests
ENV PIPX_HOME /opt/pipx/pipx
ENV PIPX_BIN_DIR /opt/pipx/bin
RUN pip3 install -r /tmp/manifests/pip3.txt
RUN xargs -l pipx install < /tmp/manifests/pipx.txt
# Install ruby manifests
RUN xargs gem install < /tmp/manifests/gems.txt
# Install go manifests
ENV GOPATH /opt/go
RUN xargs go get < /tmp/manifests/go.txt
# Install rust manifests
ENV CARGO_HOME /opt/cargo
# No crates yet :)
# Install git repositories
WORKDIR /opt
RUN xargs -l git clone --depth 1 < /tmp/manifests/git.txt

# Install from custom scripts
ADD scripts /tmp/scripts
RUN /tmp/scripts/all.sh

# Adds skeleton files to the root file system
ADD skeleton/ /

# Clean up apt
RUN apt-get autoremove -y \
    && apt-get clean

# Clean up tmp directory
RUN rm -rf /tmp/*

# Export the X11 display for use with GUI applications on host (macOS only)
# https://docs.docker.com/docker-for-mac/networking/#use-cases-and-workarounds
ENV DISPLAY=host.docker.internal:0

RUN chsh -r /usr/bin/zsh
ADD scripts/entry.sh /entry.sh
WORKDIR $HOME
CMD ["/entry.sh"]
