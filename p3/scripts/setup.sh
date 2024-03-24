#!/bin/sh

operation_title(){
    echo "\n\n========================= $1 ========================="
}

wait_command()
{
    sleep 5
    while [ "$(kubectl get pods -n $1 --field-selector=status.phase!=Succeeded,status.phase!=Running  --no-headers | wc -l)" -gt 0 ]; do
        echo "Waiting for $1 pods to be ready..."
        sleep 10
    done

    echo "$1 pods are ready!"
    sleep 3
}

# cleanup
rm -rf ../useful-output.txt


# ACL entry for your user to the Docker socket
sudo setfacl -m u:$USER:rw /var/run/docker.sock
sudo setfacl -m u:$USER:rw /run/docker.sock


### Start Docker
sudo systemctl start docker


### create cluster
operation_title "Create iot-dev cluster"
k3d cluster create iot

## Create namespaces
kubectl create namespace argocd
kubectl create namespace dev

# Deploy Argo CD using a YAML file
operation_title "Deploy Argo-CD"
wait_command 'kube-system'
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
wait_command 'argocd'

# # Expose Argo CD service to the host machine
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'

# # Get the port for accessing Argo CD
NODE_PORT=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.spec.ports[0].nodePort}')

# # Get the IP address of any node in the cluster
NODE_IP=$(kubectl get nodes -o jsonpath='{.items[0].status.addresses[0].address}')


# operation_title "Generating useful-output.txt file"
# Print instructions for accessing Argo CD
echo "Argo CD is now accessible at: http://${NODE_IP}:${NODE_PORT}"
sleep 5


operation_title "Creating ArgoCD App"
# ArgoCD server details
ARGOCD_SERVER="${NODE_IP}:${NODE_PORT}"
ARGOCD_USERNAME="admin"
ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)
APPLICATION_NAME="wil-app"

# Log in to ArgoCD server
argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD --insecure

# Create or update application
argocd app create $APPLICATION_NAME \
    --repo 'https://github.com/amzilayoub/inception-of-things.git' \
    --path 'p3/app' \
    --dest-namespace dev \
    --dest-server https://kubernetes.default.svc \
    --sync-policy automated \
    --auto-prune \
    --sync-option PollingInterval=10s
