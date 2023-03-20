#!/bin/bash

# Set Terraform version via tfswitch
echo "${INFO} Downloading and installing Terraform version ${TF_VERSION} via tfswitch"
tfswitch ${TF_VERSION}
echo 'complete -C /usr/local/bin/terraform terraform' >> "${HOME}/.bashrc"
terraform --version

# Set Terragrunt version via tgswitch
echo "${INFO} Downloading and installing Terragurnt version ${TG_VERSION} via tgswitch"
tgswitch ${TG_VERSION}
echo 'complete -C /usr/local/bin/terraform terragrunt' >> "${HOME}/.bashrc"
terragrunt --version

source ~/.bashrc
echo "${INFO} Done with user setup!"