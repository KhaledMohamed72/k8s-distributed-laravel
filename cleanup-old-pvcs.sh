#!/bin/bash
# Script to clean up old PVCs from volumeClaimTemplates
# These PVCs are no longer needed since we're using standalone PVCs

set -e

echo "Cleaning up old PVCs from volumeClaimTemplates..."

# Delete old PVCs created by volumeClaimTemplates
kubectl delete pvc mysql-storage-mysql-0 -n laravel --ignore-not-found=true
kubectl delete pvc redis-storage-redis-0 -n laravel --ignore-not-found=true

echo ""
echo "✅ Old PVCs deleted!"
echo ""
echo "Note: The standalone PVCs (mysql-pvc, redis-pvc) will bind to PVs after syncing ArgoCD"

