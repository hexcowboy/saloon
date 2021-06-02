FROM docker.io/ubuntu:focal
ENV HOME /root

# Add repositories
# ...

# Update repository sources and upgrade packages
RUN apt-get update && apt-get upgrade -y

# Install dependencies
RUN apt-get install -y curl wget

# Install prompt
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- --yes \
  && echo 'eval "$(starship init bash)"' >> /root/.bashrc

# Add install scripts and run them all
ADD scripts /tmp/scripts
RUN bash /tmp/scripts/00-start.sh

WORKDIR $HOME
CMD /bin/bash
