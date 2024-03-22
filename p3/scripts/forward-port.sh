#!/bin/bash

operation_title(){
    echo "\n\n========================= $1 ========================="
}

# operation_title "Forward port"
kubectl port-forward -n argocd svc/argocd-server 8080:443 & kubectl port-forward -n dev svc/playground-service 8888:8888 # after this command, you can access argocd on localhost:8080

# ArgoCD server details
# ARGOCD_SERVER="localhost:8080"
# ARGOCD_USERNAME="admin"
# ARGOCD_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d)
# APPLICATION_NAME="wil-app"

# # Log in to ArgoCD server
# argocd login $ARGOCD_SERVER --username $ARGOCD_USERNAME --password $ARGOCD_PASSWORD --insecure

# # Create or update application
# argocd app create $APPLICATION_NAME \
#     --repo 'https://github.com/amzilayoub/inception-of-things.git' \
#     --path 'p3/app' \
#     --dest-namespace default \
#     --dest-server https://kubernetes.default.svc \
#     --sync-policy automated \
#     --auto-prune
