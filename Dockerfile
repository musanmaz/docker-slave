FROM jenkins/slave:4.3-1-alpine

ARG MAVEN_VERSION=3.5.4
ARG GRADLE_VERSION=4.2.1

ENV PATH=$PATH:/opt/gradle/bin:/opt/maven/bin:/opt/nodejs12/bin

USER root

RUN apk add --update --no-cache curl unzip tar docker openrc && \
    rc-update add docker boot && \
    curl -LOk https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
    unzip gradle-${GRADLE_VERSION}-bin.zip -d /opt && \
    rm -f gradle-${GRADLE_VERSION}-bin.zip && \
    ln -s /opt/gradle-${GRADLE_VERSION} /opt/gradle && \
    curl -LOk https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip && \
    unzip apache-maven-${MAVEN_VERSION}-bin.zip -d /opt && \
    rm -f apache-maven-${MAVEN_VERSION}-bin.zip && \
    ln -s apache-maven-${MAVEN_VERSION} /opt/maven && \
    mkdir -p $HOME/.m2 && \
    mkdir -p $HOME/.gradle && \
    apk add --update-cache python python-dev py-pip build-base && \
    pip install virtualenv && \
    rm -rf /var/cache/apk/* && \
    apk add  --no-cache nodejs npm && \
    apk add openjdk11 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/community && \
    npm install -g dredd newman newman-reporter-htmlextra
