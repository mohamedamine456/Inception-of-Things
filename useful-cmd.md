# have an eye on the pod state and logs
kubectl describe pod <pod-name> -n argocd

# delete the changes applied by the yaml file
kubectl delete -f ../confs/argocd.yaml

# list the pods, service...
kubectl get pods
kubectl get services

# to delete a pod
kubectl delete pod playground-deployment-7555d94d4-sq8vh -n argocd

# to test quickly
kubectl run -it --rm dns-test --image=busybox --restart=Never -- /bin/sh