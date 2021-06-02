FROM docker.io/ubuntu:focal
ENV HOME /root

# Update repository sources and upgrade packages
RUN apt-get update && apt-get upgrade -y

# Add install scripts and run them all
ADD scripts /tmp/scripts
RUN bash /tmp/scripts/00-start.sh

WORKDIR $HOME
CMD /bin/bash
