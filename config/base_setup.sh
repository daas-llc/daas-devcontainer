#!/bin/bash

# Setup Jenkins user
echo "${INFO} Creating Jenkins User"
groupadd ${GROUP} -g ${GID}
useradd -c "Jenkins user" -d "${HOME}" -u "${UID}" -g "${GID}" -m "${USER}"
cp -r /etc/skel/. "${HOME}"
cp /etc/skel/.bashrc "${HOME}/.profile"
sed -i 's/bashrc/profile/g' "${HOME}/.profile"
touch "/etc/profile.d/z_local_aliashes.sh"
mkdir -p "${HOME}/.jenkins" "${HOME}/.bin" "${HOME}/agent" "${HOME}/.local/bin" "/usr/share/jenkins"

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
echo "${INFO} Downloading and installing Cmake version ${CMAKE_VERSION}"
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

# Saml2aws install
echo "${INFO} Downloading and installing saml2aws ${SAML2AWS_VERSION}"
curl -sfL https://github.com/Versent/saml2aws/releases/download/v${SAML2AWS_VERSION}/saml2aws_${SAML2AWS_VERSION}_linux_amd64.tar.gz | tar -xzv -C ~/.bin saml2aws
chmod u+x ~/.bin/saml2aws
echo 'source <(saml2aws --completion-script-bash)' >> "${HOME}/.bashrc"
saml2aws --version

# ECS CLI Install
echo "${INFO} Downloading and installing latest amazon ecs cli"
curl -sfL https://amazon-ecs-cli.s3.amazonaws.com/ecs-cli-linux-amd64-latest -O "${HOME}/.bin"

# Please build install
echo "${INFO} Downloading and installing Please Build version ${PLZ_BUILD_VERSION}"
curl -skL https://get.please.build > please.sh
sh ./please.sh "${PLZ_BUILD_VERSION}"
echo 'source <(plz --completion_script)' >> "${HOME}/.bashrc"
rm -f please.sh
plz --version

# Tfswitch install
echo "${INFO} Downloading and installing latest version of tfswitch"
curl -sSfL https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
chmod 777 /usr/local/bin

# Tgswitch install
echo "${INFO} Downloading and installing latest version of tgswitch"
curl -sSfL https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
chmod 777 /usr/local/bin

# Tflint install
echo "${INFO} Downloading and installing latest version of tflint"
curl -sSfL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
chmod 777 /usr/local/bin

# AWS CLI install

# AWS Serverless Application Model CLI install

# Action hero install

# Permissions finalization
chown "${USER}":"${GROUP}" -R "${HOME}"
chmod 777 -R "${HOME}" "/tmp" "/etc/profile.d" "/var/lang"