FROM amazonlinux:latest

WORKDIR /tmp

# Create user and directories
ARG USER=daasdev
ARG GROUP=daasllc
ARG GID=1234
ARG UID=5678

# Tool Versions
ARG PLZ_BUILD_VERSION="16.27.3"
ARG SAML2AWS_VERSION="2.36.4"
ARG NVM_VERSION="0.39.3"
ARG NPM_VERSION="16"
ARG CORRETO_JDK_VERSION="17"
ARG PYTHON_VERSION="39"
ARG CMAKE_VERSION="3.25.2"
ARG GOLANG_VERSION="1.20.1"

# Environment Variables
ENV HOME="/home/${USER}"
ENV TF_VERSION="1.3.9"
ENV TG_VERSION="0.44.4"
ENV JAVA_HOME="/usr/lib/jvm/java-${CORRETO_JDK_VERSION}-amazon-corretto"
ENV GO_PATH="${HOME}/go"
ENV PATH="${HOME}/.local/bin:${HOME}/go/bin:${HOME}/.bin:${HOME}/.please:${PATH}"
ENV AWS_DEFAULT_PROFILE="default"
ENV INFO="[INFO]"
ENV ERROR="[ERROR]"
ENV WARN="[WARN]"
ENV AWS_CLI_AUTO_PROMPT="on-partial"
ENV MAVEN_HOME="/${HOME}/.bin/maven"
ENV MAVEN_CONFIG="${HOME}/.m2"
# COPY config/.saml2aws ${HOME}

# Base setup
COPY config/base_setup.sh base_setup.sh
RUN mkdir -p "/home/${USER}" && chmod +x base_setup.sh; \
    ./base_setup.sh; \
    rm -rf /tmp

# User tools setup
USER ${USER}
COPY config/install_user_tools.sh install_user_tools.sh
RUN chmod +x install_user_tools.sh; \
    ./install_user_tools.sh; 

ENV PATH="${NVM_DIR}/versions/node/v${NPM_VERSION}/bin:${PATH}"

WORKDIR ${HOME}