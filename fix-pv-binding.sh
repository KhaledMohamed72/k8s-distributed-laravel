#!/bin/bash
# Script to fix PVs stuck in Terminating state
# This releases PVs from old PVCs so they can bind to new ones

set -e

echo "Fixing PVs stuck in Terminating state..."

# Check if old PVCs exist in default namespace
echo "Checking for old PVCs in default namespace..."
kubectl get pvc mysql-storage-mysql-0 -n default --ignore-not-found=true
kubectl get pvc redis-storage-redis-0 -n default --ignore-not-found=true

# Delete old PVCs in default namespace if they exist
echo ""
echo "Deleting old PVCs in default namespace..."
kubectl delete pvc mysql-storage-mysql-0 -n default --ignore-not-found=true
kubectl delete pvc redis-storage-redis-0 -n default --ignore-not-found=true

# Wait a moment
sleep 2

# Patch PVs to remove finalizers and claim references
echo ""
echo "Patching PVs to release them..."
kubectl patch pv mysql-pv -p '{"metadata":{"finalizers":null},"spec":{"claimRef":null}}' || true
kubectl patch pv redis-pv -p '{"metadata":{"finalizers":null},"spec":{"claimRef":null}}' || true

# Wait for PVs to be released
echo ""
echo "Waiting for PVs to be released..."
sleep 5

# Check PV status
echo ""
echo "Current PV status:"
kubectl get pv

echo ""
echo "✅ PVs should now be Available. Sync ArgoCD to bind new PVCs."

