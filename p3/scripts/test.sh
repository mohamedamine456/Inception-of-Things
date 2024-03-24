#!/bin/bash

while [[ -z "${EXTERNAL_IP}" ]]; do
    echo "Waiting for external IP..."
    EXTERNAL_IP=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    echo "External IP: ${EXTERNAL_IP}"
    sleep 5
done