FROM debian:13.1

RUN apt update && apt upgrade -y
RUN apt install curl sudo -y
RUN curl -O https://download.java.net/java/GA/jdk23.0.2/6da2a6609d6e406f85c491fcb119101b/7/GPL/openjdk-23.0.2_linux-x64_bin.tar.gz --output-dir ~/
RUN tar zxf ~/openjdk-23.0.2_linux-x64_bin.tar.gz -C /usr/local/
RUN rm ~/openjdk-23.0.2_linux-x64_bin.tar.gz
RUN curl -O https://dlcdn.apache.org/maven/maven-3/3.9.14/binaries/apache-maven-3.9.14-bin.tar.gz --output-dir ~/
RUN tar zxf ~/apache-maven-3.9.14-bin.tar.gz -C /usr/local
RUN groupadd java
RUN useradd -g java -G sudo java -d /workspace -s /bin/bash
RUN mkdir /workspace && chown java:java /workspace && chmod 700 /workspace
RUN echo "java ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/java
ENV JAVA_HOME=/usr/local/jdk-23.0.2
ENV CLASSPATH=${JAVA_HOME}/lib
ENV MAVEN_HOME=/usr/local/apache-maven-3.9.14
ENV PATH=${PATH}:${JAVA_HOME}/bin:${MAVEN_HOME}/bin

# RUN apt install -y maven
WORKDIR /workspace
USER java