FROM amazonlinux:2
FROM maven:3.8.3-amazoncorretto-11 as maven
FROM jenkins/agent:latest-jdk11 as agent

WORKDIR /tmp

# Create user and directories
ARG USER=jenkins
ARG GROUP=jenkins
ARG GID=2345
ARG UID=5432
RUN mkdir -p "/home/${USER}"

# Tool Versions
ARG PLZ_BUILD_VERSION="16.11.0"
ARG ACTION_HERO_VERSION=""
ARG SAML2AWS_VERSION="2.32.0"
ARG NVM_VERSION="0.39.0"
ARG NPM_VERSION="14.18.0"
ARG TERRAFORM_VERSION="1.0.8"
ARG TERRAGRUNT_VERSION="0.34.1"
ARG CONFTEST_VERSION="0.28.1"
ARG CORRETO_JDK_VERSION="11"
ARG CMAKE_VERSION="3.21.3"
ARG PYTHON_VERSION="3.9.7"
ARG GOLANG_VERSION="1.17"

ENV HOME="/home/${USER}"

ENV JAVA_HOME="/usr/lib/jvm/java-${CORRETO_JDK_VERSION}-amazon-corretto"
ENV GO_PATH="${HOME}/go"
ENV PATH="${HOME}/.local/bin:${HOME}/go/bin:${HOME}/.bin:${HOME}/.please:${PATH}"
ENV AWS_DEFAULT_PROFILE="default"
ENV INFO="[INFO]"
ENV ERROR="[ERROR]"
ENV WARN="[WARN]"
ENV AWS_CLI_AUTO_PROMPT="on-partial"

# Base setup
COPY config/base_setup.sh base_setup.sh
RUN chmod +x base_setup.sh; \
    ./base_setup.sh; \
    rm -f base_setup.sh

# Maven setup
ENV MAVEN_HOME="/${HOME}/.bin/maven"
ENV MAVEN_CONFIG="${HOME}/.m2"
COPY --from=maven /usr/share/maven ${MAVEN_HOME}

# User tools setup
USER ${USER}
COPY config/install_user_tools.sh install_user_tools.sh
RUN chmod +x install_user_tools.sh; \
    ./install_user_tools.sh; \
    rm -f install_user_tools.sh

ENV PATH="${NVM_DIR}/versions/node/v${NPM_VERSION}/bin:${PATH}"

VOLUME ${HOME}/.jenkins
VOLUME ${HOME}/agent
WORKDIR ${HOME}