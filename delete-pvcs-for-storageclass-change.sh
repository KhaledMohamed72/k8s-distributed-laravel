#!/bin/bash
# Script to delete PVCs so they can be recreated with new storageClassName
# This is needed because storageClassName is immutable in PVCs

set -e

echo "=========================================="
echo "Deleting PVCs to change storageClassName"
echo "=========================================="
echo ""

# Note: This will delete the data in the PVCs
# Make sure you have backups if needed

echo "⚠️  WARNING: This will delete existing PVCs and their data!"
echo "Press Ctrl+C to cancel, or wait 5 seconds to continue..."
sleep 5

# Delete StatefulSets first (they depend on PVCs)
echo "Step 1: Deleting StatefulSets..."
kubectl delete statefulset mysql -n laravel --ignore-not-found=true
kubectl delete statefulset redis -n laravel --ignore-not-found=true
echo "✅ StatefulSets deleted"
echo ""

# Wait a moment
sleep 2

# Delete PVCs
echo "Step 2: Deleting PVCs..."
kubectl delete pvc mysql-pvc -n laravel --ignore-not-found=true
kubectl delete pvc redis-pvc -n laravel --ignore-not-found=true
echo "✅ PVCs deleted"
echo ""

# Wait for cleanup
echo "Step 3: Waiting for cleanup..."
sleep 3

# Check status
echo "Step 4: Current PVC status:"
kubectl get pvc -n laravel
echo ""

echo "=========================================="
echo "✅ PVCs deleted successfully!"
echo ""
echo "Next steps:"
echo "1. Sync your ArgoCD application"
echo "2. ArgoCD will recreate PVCs with 'standard' storageClassName"
echo "3. StatefulSets will be recreated and will use the new PVCs"
echo ""
echo "After syncing, verify with:"
echo "  kubectl get pvc -n laravel"
echo "  kubectl get statefulset -n laravel"
echo "=========================================="

