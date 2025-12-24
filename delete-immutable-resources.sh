#!/bin/bash
# Script to delete immutable resources that need to be recreated
# Run this script before syncing ArgoCD application
# 
# NOTE: This script preserves PVCs and PVs - only deletes StatefulSets and StorageClass
# The PVCs (mysql-pvc, redis-pvc) will be reused by the new StatefulSets

set -e

echo "Deleting immutable resources..."

# Delete StatefulSets (they will be recreated by ArgoCD with correct configuration)
# Note: PVCs are preserved and will be reused
kubectl delete statefulset mysql -n laravel --ignore-not-found=true
kubectl delete statefulset redis -n laravel --ignore-not-found=true

# Delete StorageClass (it will be recreated by ArgoCD)
kubectl delete storageclass retain-sc --ignore-not-found=true

echo "Waiting for resources to be fully deleted..."
sleep 5

echo ""
echo "✅ Resources deleted successfully!"
echo ""
echo "Next steps:"
echo "1. Sync the ArgoCD application (it will recreate the resources)"
echo "2. The PVCs (mysql-pvc, redis-pvc) will be reused by the new StatefulSets"
echo "3. Verify with: kubectl get statefulset,pvc -n laravel"

