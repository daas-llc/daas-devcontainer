#!/bin/bash

# Setup ${USER} 
yum install shadow-utils.x86_64 sudo -y
echo "${INFO} Creating user: ${USER} ..."
groupadd ${GROUP} -g ${GID}
useradd -c "${USER} user" -d "${HOME}" -u "${UID}" -g "${GID}" -m "${USER}"
cp -r /etc/skel/. "${HOME}"
cp /etc/skel/.bashrc "${HOME}/.profile"
sed -i 's/bashrc/profile/g' "${HOME}/.profile"
mkdir -p "${HOME}/.bin" "${HOME}/.local/bin" 

# Setup ${USER}
USER_ID=$(id -u)
GROUP_ID=$(id -g)
if [ x"$USER_ID" != x"0" ]; then
    echo "${USER}:!!:${USER_ID}:${GROUP_ID}:${USER} user:${HOME}:/bin/bash" >> /etc/passwd
fi

# Yummy yum installs
sudo yum update -y --security
sudo yum install -y https://corretto.aws/downloads/latest/amazon-corretto-${CORRETO_JDK_VERSION}-x64-linux-jdk.rpm
sudo yum groupinstall -y development
sudo yum install -y jq wget vim bash-completion openssl hostname
sudo yum install -y openssl-devel bzip2-devel libffi-devel zlib-devel
sudo yum clean all  

# Python and pip install and alias updates
curl https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz --output Python-${PYTHON_VERSION}.tgz
tar -xzf Python-${PYTHON_VERSION}.tgz
cd Python-${PYTHON_VERSION}
./configure --enable-optimizations
make altinstall && cd ..
python${PYTHON_MAJOR_MINOR} -m pip install pip --upgrade
python${PYTHON_MAJOR_MINOR} --version
pip --version
echo "alias python=python${PYTHON_MAJOR_MINOR}" >> ${HOME}/.bashrc && echo "alias python3=python${PYTHON_MAJOR_MINOR}" >> ${HOME}/.bashrc

# CMake install
echo "${INFO} Downloading and installing Cmake version ${CMAKE_VERSION}"
curl -sSfL https://github.com/Kitware/CMake/releases/download/v"${CMAKE_VERSION}"/cmake-"${CMAKE_VERSION}"-linux-x86_64.sh -o cmake-linux.sh
sh cmake-linux.sh --skip-license --prefix=/usr
rm -f cmake-linux.sh
cmake --version

# Maven install
sudo curl https://repos.fedorapeople.org/repos/dchen/apache-maven/epel-apache-maven.repo -o /etc/yum.repos.d/epel-apache-maven.repo
sudo sed -i s/\$releasever/6/g /etc/yum.repos.d/epel-apache-maven.repo
sudo yum install -y apache-maven
TMP_JAVA_HOME=$(readlink -f /usr/bin/java)
echo $TMP_JAVA_HOME
echo "JAVA_HOME=${TMP_JAVA_HOME::-9}" >> ${HOME}/.bashrc

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
sudo chmod u+x ~/.bin/saml2aws
saml2aws --version

# AWS Copilot CLI Install
echo "${INFO} Downloading and installing AWS Copilot CLI"
curl -Lo copilot https://github.com/aws/copilot-cli/releases/latest/download/copilot-linux && chmod +x copilot && sudo mv copilot /usr/local/bin/copilot && copilot --version

# Please build install
echo "${INFO} Downloading and installing Please Build version ${PLZ_BUILD_VERSION}"
curl -skL https://get.please.build > please.sh
sh ./please.sh "${PLZ_BUILD_VERSION}"
rm -f please.sh
plz --version

# Tfswitch install
echo "${INFO} Downloading and installing latest version of tfswitch"
curl -sSfL https://raw.githubusercontent.com/warrensbox/terraform-switcher/release/install.sh | bash
sudo chmod 777 /usr/local/bin

# Tgswitch install
echo "${INFO} Downloading and installing latest version of tgswitch"
curl -sSfL https://raw.githubusercontent.com/warrensbox/tgswitch/release/install.sh | bash
sudo chmod 777 /usr/local/bin

# Tflint install
echo "${INFO} Downloading and installing latest version of tflint"
curl -sSfL https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
sudo chmod 777 /usr/local/bin

# AWS CLI install
echo "${INFO} Downloading and installing latest version of AWS CLI V2"
curl -sSfL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
unzip -q awscliv2.zip
./aws/install
rm -rf ./aws
rm -f ./awscliv2.zip

# Install NodeJS via Node Version Manager
echo "${INFO} Downloading and installing NodeJS via NVM"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
source ~/.bashrc
nvm install ${NODE_VERSION}
npm install --global yarn
npm --version
node --version

# Permissions finalization
sudo chown "${USER}":"${GROUP}" -R "${HOME}"
sudo chmod 777 -R "${HOME}" 