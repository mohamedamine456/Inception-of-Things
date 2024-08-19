#!/bin/sh
apk update && apk upgrade && apk add curl

export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $1  --bind-address=$1 --advertise-address=$1"

curl -sfL https://get.k3s.io |  sh -

# Wait for the k3s service to be active
sleep 30

sudo cp /var/lib/rancher/k3s/server/node-token /vagrant/scripts/

echo "[INFO]  Successfully installed k3s on server node"

echo "alias k='kubectl'" >> /etc/profile.d/00-aliases.sh