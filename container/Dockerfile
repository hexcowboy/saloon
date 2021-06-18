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

# Install Kali repositories
RUN echo "deb http://http.kali.org/kali kali-rolling main non-free contrib" | sudo tee -a /etc/apt/sources.list \
    && wget -q -O - https://archive.kali.org/archive-key.asc | apt-key add \
    && apt-get update

# Install apt manifests
ADD manifests/apt.txt /tmp/manifests/apt.txt
RUN xargs apt-get install -y < /tmp/manifests/apt.txt

# Install python manifest
ADD manifests/pip3.txt /tmp/manifests/pip3.txt
RUN pip3 install -r /tmp/manifests/pip3.txt

# Install pipx manifest
ENV PIPX_HOME /opt/pipx/pipx
ENV PIPX_BIN_DIR /opt/pipx/bin
ADD manifests/pipx.txt /tmp/manifests/pipx.txt
RUN xargs -l pipx install < /tmp/manifests/pipx.txt

# Install ruby manifest
ADD manifests/gems.txt /tmp/manifests/gems.txt
RUN xargs gem install < /tmp/manifests/gems.txt

# Install go manifest
ADD manifests/go.txt /tmp/manifests/go.txt
ENV GOPATH /opt/go
RUN GO111MODULE=on xargs go get -v < /tmp/manifests/go.txt

# Install rust manifest
# ADD manifests/crates.txt /tmp/manifests/crates.txt
ENV CARGO_HOME /opt/cargo

# Install git repositories
ADD manifests/git.txt /tmp/manifests/git.txt
WORKDIR /opt
RUN xargs -l git clone --depth 1 < /tmp/manifests/git.txt

# Install from custom scripts
ADD scripts/installers /tmp/scripts/installers
RUN /tmp/scripts/installers/all.sh
RUN rm -rf /tmp/installers/

# Adds skeleton files to the root file system
ADD skeleton/ /

# Clean up apt
RUN apt-get autoremove -y \
    && apt-get clean

# Export the X11 display for use with GUI applications on host (macOS only)
# https://docs.docker.com/docker-for-mac/networking/#use-cases-and-workarounds
ENV DISPLAY=host.docker.internal:0

RUN chsh -s /usr/bin/zsh
ADD scripts/entry.sh /entry.sh
WORKDIR $HOME
ENTRYPOINT ["/entry.sh"]
