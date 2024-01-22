#!/bin/bash

# Install K3s
export INSTALL_K3S_EXEC="--write-kubeconfig-mode=644 --tls-san $(hostname) --node-ip $1  --bind-address=$1 --advertise-address=$1 --no-deploy traefik"

curl -sfL https://get.k3s.io | sh -

echo "alias k=\"sudo kubectl\"" >> /etc/profile

# Wait for the k3s service to be active
sleep 10

# Install nginx-ingress controller
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.34.1/deploy/static/provider/cloud/deploy.yaml
# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.32.0/deploy/static/provider/cloud/deploy.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.7.1/deploy/static/provider/baremetal/deploy.yaml
# Wait for a few seconds to ensure the ingress controller is up
sleep 20

# delete admission webhook
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission

# Deploy the web applications
kubectl apply -f /vagrant/confs/app1.yaml
kubectl apply -f /vagrant/confs/app2.yaml
kubectl apply -f /vagrant/confs/app3.yaml

# Set up the load balancer
kubectl apply -f /vagrant/confs/loadbalancer.yaml

# Set up Ingress to route traffic
kubectl apply -f /vagrant/confs/ingress.yaml
