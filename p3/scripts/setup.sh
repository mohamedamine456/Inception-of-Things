#!/bin/sh

operation_title(){
    echo "\n\n========================= $1 ========================="
}
# cleanup
rm -rf ../useful-output.txt


# ACL entry for your user to the Docker socket
sudo setfacl -m u:$USER:rw /var/run/docker.sock
sudo setfacl -m u:$USER:rw /run/docker.sock

### Start Docker
operation_title "Start Docker"
sudo systemctl start docker

### Create namespaces
kubectl create namespace argocd
kubectl create namespace dev

### create cluster
operation_title "Create iot-dev cluster"
k3d cluster create iot-dev

# Wait for the cluster to be ready
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# Deploy Argo CD using a YAML file
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Expose Argo CD service to the host machine
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Get the port for accessing Argo CD
NODE_PORT=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.ports[0].nodePort}')

# Get the IP address of any node in the cluster
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')

# Print instructions for accessing Argo CD
echo "Argo CD is now accessible at: http://${NODE_IP}:${NODE_PORT}" >> ../useful-output.txt

# Credentials to connect to Argo CD
echo -n "Password to connect to Argo CD is : " >> ../useful-output.txt
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo >> ../useful-output.txt

