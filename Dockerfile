FROM docker.io/ubuntu:focal

# Add repositories
# ...

# Update repository sources and upgrade packages
RUN apt-get update && apt-get upgrade -y

# Install dependencies
RUN apt-get install -y curl wget

# Install prompt
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- --yes \
  && echo 'eval "$(starship init bash)"' >> /root/.bashrc


CMD /bin/bash
