FROM mcr.microsoft.com/devcontainers/javascript-node:1-22-bookworm

ARG USERNAME=node

USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends jq openjdk-17-jre-headless \
    && rm -rf /var/lib/apt/lists/*

RUN npm install --global @salesforce/cli

ENV JAVA_HOME=/usr/lib/jvm/default-java
ENV PATH="${JAVA_HOME}/bin:${PATH}"

RUN mkdir -p /home/${USERNAME}/.sf /home/${USERNAME}/.sfdx \
    && chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/.sf /home/${USERNAME}/.sfdx

USER ${USERNAME}
