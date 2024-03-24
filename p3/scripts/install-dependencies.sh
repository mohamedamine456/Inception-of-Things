#!/bin/sh

#########################
### Helper function
#########################

operation_title(){
    echo "\n\n========================= $1 ========================="
}

already_installed()
{
    echo "$1 Is Already Installed"
}

# Pre installation
operation_title "Pre install"

sudo apt-get update

#########################
### Install Docker
#########################
operation_title "Install Docker"

if [ -z $(command -v docker) ]; then

    # Install packages to allow apt to use a repository over HTTPS
    sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common

    # Add Docker’s official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    # Set up the stable repository
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

    # Update the package index again
    sudo apt-get update

    # Install Docker Engine
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io
else
    already_installed "Docker"
fi


#########################
### Install k3d
#########################
operation_title "Install k3d"

if [ -z $(command -v k3d) ]; then

    # download the installation
    curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

else
    already_installed "K3d"
fi

#########################
# install kubectl
#########################

operation_title "Install Kubectl"

if [ -z $(command -v kubectl) ]; then

    # Download the kubectl binary
    sudo curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"

    # Make the kubectl binary executable
    sudo chmod +x kubectl

    # Move the kubectl binary to a directory in your PATH
    sudo mv kubectl /usr/local/bin/

else
    already_installed "kubectl"
fi


#########################
# install kubectl
#########################

operation_title "Install Argo-CD CLI"

if [ -z $(command -v argocd) ]; then
    # Download the ArgoCD CLI binary
    curl -LO https://github.com/argoproj/argo-cd/releases/latest/download/argocd-darwin-amd64

    # Make the binary executable
    chmod +x argocd-darwin-amd64

    # Move the binary to a directory included in your PATH
    sudo mv argocd-darwin-amd64 /usr/local/bin/argocd
else
    already_installed "argocd"
fi
