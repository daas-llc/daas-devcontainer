#!/bin/bash

# Set Terraform version via tfswitch
echo "${INFO} Downloading and installing Terraform version ${TERRAFORM_VERSION} via tfswitch"
tfswitch ${TERRAFORM_VERSION}
echo 'complete -C /usr/local/bin/terraform terraform' >> "${HOME}/.bashrc"
mkdir -p /tmp/.terraform.d/plugin-cache/
chmod 777 -R /tmp/.terraform.d
terraform --version

# Set Terragrunt version via tgswitch
echo "${INFO} Downloading and installing Terragurnt version ${TERRAGRUNT_VERSION} via tgswitch"
tgswitch ${TERRAGRUNT_VERSION}
echo 'complete -C /usr/local/bin/terraform terragrunt' >> "${HOME}/.bashrc"
terragrunt --version

# Install NodeJS via Node Version Manager
echo "${INFO} Downloading and installing NodeJS via NVM"
curl -so- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> "${HOME}/.profile"
nvm install ${NPM_VERSION}
npm install --global yarn
npm --version
node --version

# Permissions finalization
sudo chown "${USER}":"${GROUP}" -R "${HOME}"
sudo chmod 777 -R "${HOME}"