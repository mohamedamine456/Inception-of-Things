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
    sudo install -m 0755 -d /etc/apt/keyrings
    # Add Docker’s official GPG key
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Set up the stable repository
    # sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian bullseye stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    # Update the package index again
    sudo apt-get update

    # Install Docker Engine
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
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
# install argocd
#########################

operation_title "Install Argo-CD CLI"

if [ -z $(command -v argocd) ]; then
    # Download the ArgoCD CLI binary
    curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
    sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
    rm argocd-linux-amd64

else
    already_installed "argocd"
fi
