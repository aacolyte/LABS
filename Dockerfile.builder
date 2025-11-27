FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    sudo \
    curl \
    wget \
    docker.io \
    rpm \
    dpkg \
    bash
RUN useradd -ms /bin/bash jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER jenkins
WORKDIR /home/jenkins
COPY script.sh .
RUN chmod +x script.sh
