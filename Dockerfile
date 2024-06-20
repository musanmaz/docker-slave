FROM jenkins/slave:alpine

ARG MAVEN_VERSION=3.9.8
ARG GRADLE_VERSION=8.8

ENV PATH=$PATH:/opt/gradle/bin:/opt/maven/bin:/opt/nodejs/bin

USER root

RUN apk --update --no-cache upgrade && \
    apk add --no-cache \
        curl \
        unzip \
        tar \
        docker \
        openrc \
        python3 \
        python3-dev \
        py3-pip \
        build-base \
        nodejs \
        npm \
        openjdk11 && \
    rc-update add docker boot && \
    curl -LOk https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    rm -f gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
    curl -LOk https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip && \
    unzip apache-maven-${MAVEN_VERSION}-bin.zip -d /opt && \
    rm -f apache-maven-${MAVEN_VERSION}-bin.zip && \
    ln -s /opt/apache-maven-${MAVEN_VERSION} /opt/maven && \
    mkdir -p $HOME/.m2 && \
    mkdir -p $HOME/.gradle && \
    pip3 install virtualenv && \
    npm install -g dredd newman newman-reporter-htmlextra && \
    rm -rf /var/cache/apk/*

USER jenkins