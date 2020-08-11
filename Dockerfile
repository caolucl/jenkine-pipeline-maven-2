FROM debian:stretch-slim

RUN apt-get update && \
    apt-get install -y zip unzip curl && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/*

ARG USER_UID="1000"
ARG USER_NAME="jenkins"

RUN useradd -m -U -u $USER_UID $USER_NAME

USER $USER_NAME
RUN echo $HOME
WORKDIR /home/jenkins

RUN curl -s "https://get.sdkman.io" | bash

ARG JAVA_VERSION="11.0.8-amzn"
ARG MAVEN_VERSION="3.6.3"

RUN bash -c "source $HOME/.sdkman/bin/sdkman-init.sh && \
    yes | sdk install java $JAVA_VERSION && \
    yes | sdk install maven $MAVEN_VERSION && \
    sdk flush archives && sdk flush temp"
RUN mkdir $HOME/.m2 && chown $USER_NAME: $HOME/.m2
    
    
RUN ls -la $HOME
ENV JAVA_HOME="/home/jenkins/.sdkman/candidates/java/current"
ENV MAVEN_HOME="/home/jenkins/.sdkman/candidates/maven/current"
ENV PATH="$JAVA_HOME/bin:$MAVEN_HOME/bin:$PATH"


