FROM ubuntu:22.04

RUN apt-get update && apt-get install -y sudo curl wget rpm dpkg bash

RUN useradd -ms /bin/bash jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER root
WORKDIR /home/jenkins

COPY script.sh .
RUN chmod +x script.sh
COPY script_rpm /home/jenkins/script_rpm
COPY script /home/jenkins/script

USER jenkins
