#!/bin/bash

sudo dnf install -y unzip

# Download Terraform 1.14.5
curl -LO https://releases.hashicorp.com/terraform/1.14.5/terraform_1.14.5_linux_amd64.zip

# Unzip
unzip terraform_1.14.5_linux_amd64.zip

# Move binary to PATH
sudo mv terraform /usr/local/bin/

# Verify installation
terraform -version
