#!/bin/bash

# Setup Jenkins user
echo "${INFO} Creating Jenkins User"
groupadd ${GROUP} -g ${GID}
useradd -c "Jenkins user" -d "${HOME}" -u "${UID}" -g "${GID}" -m "${USER}"
cp -r /etc/skel/. "${HOME}"
cp /etc/skel/.bashrc "${HOME}/.profile"
sed -i 's/bashrc/profile/g' "${HOME}/.profile"
touch "/etc/profile.d/z_local_aliashes.sh"
mkdir -p "${HOME}/.jenkins" "${HOME}/.bin" "${HOME}/agent" "${HOME}/.local/bin"

# Yummy yum installs
yum install -y deltarpm
yum update -y --security
yum install -y https://corretto.aws/downloads/latest/amazon-corretto-${CORRETO_JDK_VERSION}-x64-linux-jdk.rpm
yum groupinstall -y development
yum install -y jq vim zip unzip tar gzip gcc make openssl bzip2 python3 python-pip \
               postgresql wget curl sqlite hostname bash-completion skopeo \
yum remove -y cmake
python3 --version && pip --version && psql --version && gcc --version && openssl --version

# CMake install
curl -sSfL https://github.com/Kitware/CMake/releases/download/v"${CMAKE_VERSION}"/cmake-"${CMAKE_VERSION}"-linux-x86_64.sh -o cmake-linux.sh
sh cmake-linux.sh --skip-license --prefix=/usr
rm -f cmake-linux.sh
cmake --version

# Golang install
echo "${INFO} Downloading and installing Golang version ${GOLANG_VERSION}"
mkdir -p "${HOME}/.bin/go${GOLANG_VERSION}"
curl -sSfL https://golang.org/dl/go"${GOLANG_VERSION}".linux-amd64.tar.gz | tar -xz -C "${HOME}/.bin/go${GOLANG_VERSION}"
ln -sfv "${HOME}/.bin/go${GOLANG_VERSION}/go/bin/go" "${HOME}/.bin/go"
ln -sfv "${HOME}/.bin/go${GOLANG_VERSION}/go/bin/gofmt" "${HOME}/.bin/gofmt"
go get -v github.com/aws/aws-sdk-go-v2
go get -v github.com/aws/aws-sdk-go-v2/config
go clean -cache
go clean -modcache
go version