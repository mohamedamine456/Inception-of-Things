#!/bin/bash

operation_title(){
    echo "\n\n========================= $1 ========================="
}

# operation_title "Forward port"
kubectl port-forward -n argocd svc/argocd-server 8080:443 & kubectl port-forward -n dev svc/playground-service 8888:8888 # after this command, you can access argocd on localhost:8080

