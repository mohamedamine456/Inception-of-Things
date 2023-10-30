#!/bin/bash

# Set up the initial variables
NAME=$3
TOKEN_FILE="/vagrant/scripts/node-token"
INSTALL_K3S_EXEC="agent --server https://$1:6443 --token-file $TOKEN_FILE --node-ip=$2"

# Check if TOKEN_FILE exists
if [[ ! -e $TOKEN_FILE ]]; then
  echo "Error: Token file does not exist at $TOKEN_FILE"
  exit 1
fi

# Install curl if not available
apk update && apk upgrade && apk add curl

# Attempt to download and run the installation script
if ! curl -sfL https://get.k3s.io | sh -; then
  echo "Error installing k3s"
  exit 1
fi

# Setup alias for all users
echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh