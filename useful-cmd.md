# have an eye on the pod state and logs
kubectl describe pod <pod-name> -n argocd

# delete the changes applied by the yaml file
kubectl delete -f ../confs/argocd.yaml

# list the pods, service...
kubectl get pods
kubectl get services