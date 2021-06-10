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

# Install prompt
# https://starship.rs/guide/#%F0%9F%9A%80-installation
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- -y

ADD manifests /tmp/manifests
# Install apt manifests
RUN xargs apt-get install -y < /tmp/manifests/apt.lib.txt
RUN xargs apt-get install -y < /tmp/manifests/apt.lang.txt
RUN xargs apt-get install -y < /tmp/manifests/apt.txt
# Install python manifests
RUN pip install -r /tmp/manifests/pip.txt
# Install ruby manifests
RUN xargs gem install < /tmp/manifests/gems.txt
# Install go manifests
RUN xargs go get < /tmp/manifests/go.txt
# Install rust manifests
# WARNING: these take a really long time to build
RUN xargs cargo install < /tmp/manifests/crates.txt

# Copy the zshrc to the home directory
ADD config/zshrc /root/.zshrc

# Workaround for autoremove bug
# https://github.com/pwndbg/pwndbg/issues/745
RUN apt --purge autoremove

# Clean up apt
RUN apt-get autoremove -y \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

WORKDIR $HOME
CMD /bin/zsh
