#!/bin/bash
apk update && apk upgrade && apk add curl

# Install K3s
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $1  --bind-address=$1 --advertise-address=$1"

curl -sfL https://get.k3s.io | sh -

# Wait for the k3s service to be active
sleep 45

# Ensure kubectl uses the correct config
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

# Deploy the web applications
kubectl apply -f /vagrant/confs/app1.yaml
kubectl apply -f /vagrant/confs/app2.yaml
kubectl apply -f /vagrant/confs/app3.yaml

while true; do
    not_running=$(kubectl get pods --no-headers | grep Running | wc -l)
    if [ "$not_running" -eq 5 ]; then
        echo "[INFO]: All pods are running"
        break
    else
        echo "[INFO] Some pods are not running. waiting ..."
        sleep 10
    fi
done

# Set up Ingress to route traffic
kubectl apply -f /vagrant/confs/ingress.yaml

sleep 30

while true; do
    endpoints_running=$(kubectl get endpoints app-one app-two app-three --no-headers | grep '<none>' | wc -l)
    if [ "$endpoints_running" -eq 0 ]; then
        echo "[INFO]: All endpoints are running"
        break
    else
        echo "[INFO] Some endpoints are not running. waiting ..."
        sleep 10
    fi
done

sleep 120

echo "alias k=\"sudo kubectl\"" >> /etc/profile
echo "[INFO]  Successfully installed k3s on server node"