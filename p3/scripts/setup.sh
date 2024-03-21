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


### create cluster
operation_title "Create iot-dev cluster"
k3d cluster create iot

### Create namespaces
kubectl create namespace argocd
kubectl create namespace dev

# Wait for the cluster to be ready
kubectl wait --for=condition=Ready nodes --all --timeout=300s


# Deploy Argo CD using a YAML file
operation_title "Deploy Argo-CD"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Expose Argo CD service to the host machine
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# Get the port for accessing Argo CD
NODE_PORT=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.ports[0].nodePort}')

# Get the IP address of any node in the cluster
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')


operation_title "Generating useful-output.txt file"
# Print instructions for accessing Argo CD
echo "Argo CD is now accessible at: http://${NODE_IP}:${NODE_PORT}" > ./useful-output.txt

# Credentials to connect to Argo CD
sleep 10
echo -n "Password to connect to Argo CD is : " >> ./useful-output.txt
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d && echo >> ./useful-output.txt



# Install Argo-CD CLI
operation_title "Install Argo-CD CLI"

#### COMMENT THIS FOR NOW
# Download the ArgoCD CLI binary
# curl -LO https://github.com/argoproj/argo-cd/releases/latest/download/argocd-darwin-amd64

# # Make the binary executable
# chmod +x argocd-darwin-amd64

# # Move the binary to a directory included in your PATH
# sudo mv argocd-darwin-amd64 /usr/local/bin/argocd

# # argocd login
# argocd login --insecure


operation_title "Forward port"
kubectl port-forward -n argocd svc/argocd-server 8080:443 & kubectl port-forward -n dev svc/playground-service 8888:8888 # after this command, you can access argocd on localhost:8080
