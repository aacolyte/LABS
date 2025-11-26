FROM jenkins/jenkins:lts
USER root
RUN apt-get update && \
    apt-get install -y \
    sudo \
    rpm \
    git \
    gdebi-core \
    docker.io
RUN usermod -aG docker jenkins
RUN usermod -a6 sudo jenkins
USER jenkins
EXPOSE 8080
