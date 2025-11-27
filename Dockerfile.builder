FROM ubuntu:22.04
RUN apt-get update && apt-get install -y \
    docker.io \
    git \
    rpm \
    apt-utils \ 
    sudo 
RUN useradd -m -d /home/jenkins -s /bin/bash jenkins && \
    usermod -aG docker jenkins
USER jenkins
WORKDIR /home/jenkins
