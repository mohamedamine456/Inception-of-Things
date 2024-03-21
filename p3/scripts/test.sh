#!/bin/bash

#!/bin/bash

# Step 1: Check DNS resolution
echo "Testing DNS resolution..."
kubectl exec -it dns-test -- nslookup google.com

# Step 2: Check network connectivity
echo "Testing network connectivity..."
kubectl exec -it dns-test -- ping -c 4 google.com

# Step 3: Check network configuration
echo "Checking network configuration..."
kubectl describe pod dns-test | grep -iE "IP:|PodCIDR:|Namespace:"

# Step 4: Check DNS configuration
echo "Checking DNS configuration..."
kubectl exec -it dns-test -- cat /etc/resolv.conf

# Step 5: Check pod's routing table
echo "Checking pod's routing table..."
kubectl exec -it dns-test -- ip route

# Step 6: Verify connectivity to Google's DNS server
echo "Testing connectivity to Google's DNS server (8.8.8.8)..."
kubectl exec -it dns-test -- ping -c 4 8.8.8.8

# Step 7: Verify connectivity to Google's DNS server using DNS name
echo "Testing connectivity to Google's DNS server using DNS name (google-public-dns-a.google.com)..."
kubectl exec -it dns-test -- ping -c 4 google-public-dns-a.google.com

# Step 8: Test connectivity to google.com using curl
echo "Testing connectivity to google.com using curl..."
kubectl exec -it dns-test -- curl -IsS https://www.google.com | head -n 1

# Step 9: Clean up
echo "Cleaning up..."
kubectl delete pod dns-test
