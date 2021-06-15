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

ADD manifests /tmp/manifests
# Install apt manifests
RUN xargs apt-get install -y < /tmp/manifests/apt.lib.txt
RUN xargs apt-get install -y < /tmp/manifests/apt.lang.txt
RUN xargs apt-get install -y < /tmp/manifests/apt.txt
# Install python manifests
RUN pip3 install -r /tmp/manifests/pip3.txt
# Install ruby manifests
RUN xargs gem install < /tmp/manifests/gems.txt
# Install go manifests
ENV GOPATH /tmp/go
RUN xargs go get < /tmp/manifests/go.txt
# Install git repositories
RUN while read repo; do \
        reponame=$(echo "$repo" | cut -d "/" -f2); \
        git clone --depth 1 https://github.com/$repo.git /opt/$reponame; \
    done < /tmp/manifests/git.txt

# Install from custom scripts
ADD scripts /tmp/scripts
RUN /tmp/scripts/all.sh

# Copy the defaults to the home directory
ADD skeleton/ /

# Clean up apt
RUN apt-get autoremove -y \
    && apt-get clean

# Clean up tmp directory
RUN rm -rf /tmp/*

# Export the X11 display for use with GUI applications on host
ENV DISPLAY=host.docker.internal:0

# Expose all ports to the local machine (use -P flag in docker run)
# On Linux, just use --network=host in docker run
EXPOSE 1-65535

ADD scripts/entry.sh /entry.sh
WORKDIR $HOME
CMD ["/entry.sh"]
