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

# Workaround for autoremove bug
# https://github.com/pwndbg/pwndbg/issues/745
RUN apt-get purge -y command-not-found \
    && apt-get --purge -y autoremove \
    && apt-get update \
    && apt-get full-upgrade -y \
    && apt-get autoremove \
    && apt-get clean

# Install prompt
# https://starship.rs/guide/#%F0%9F%9A%80-installation
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- -y

# Install contributed software
ADD scripts /tmp/scripts
ADD manifests /tmp/manifests

# Install apt manifests
RUN xargs apt-get install -y < /tmp/manifests/apt.lib.txt
RUN xargs apt-get install -y < /tmp/manifests/apt.lang.txt
RUN xargs apt-get install -y < /tmp/manifests/apt.txt
# Install python manifests
RUN pip install -r /tmp/manifests/pip.txt
RUN /tmp/scripts/install-python2-pip.sh
RUN pip2 install -r /tmp/manifests/pip2.txt
# Install ruby manifests
RUN xargs gem install < /tmp/manifests/gems.txt
# Install go manifests
RUN xargs go get < /tmp/manifests/go.txt
# Install rust manifests
# WARNING: these take a really long time to build
RUN xargs cargo install < /tmp/manifests/crates.txt

# Copy the defaults to the home directory
ADD skeleton/ /

# Clean up apt
RUN apt-get autoremove -y \
    && apt-get clean

WORKDIR $HOME
CMD /bin/zsh
