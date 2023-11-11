#!/bin/bash

# Install curl if not available
apk update && apk upgrade && apk add curl

# Set up the initial variables
export TOKEN_FILE="/vagrant/scripts/node-token"
export INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file $TOKEN_FILE --node-ip=$2"

# download and run the installation script
curl -sfL https://get.k3s.io | sh -

# Setup alias for all users
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh