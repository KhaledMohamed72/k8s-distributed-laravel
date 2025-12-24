# PowerShell script to delete immutable resources that need to be recreated
# Run this script before syncing ArgoCD application
# 
# NOTE: This script preserves PVCs and PVs - only deletes StatefulSets and StorageClass
# The PVCs (mysql-pvc, redis-pvc) will be reused by the new StatefulSets

$ErrorActionPreference = "Continue"

Write-Host "Deleting immutable resources..." -ForegroundColor Yellow

# Delete StatefulSets (they will be recreated by ArgoCD with correct configuration)
# Note: PVCs are preserved and will be reused
kubectl delete statefulset mysql -n laravel --ignore-not-found=true
kubectl delete statefulset redis -n laravel --ignore-not-found=true

# Delete StorageClass (it will be recreated by ArgoCD)
kubectl delete storageclass retain-sc --ignore-not-found=true

Write-Host "Waiting for resources to be fully deleted..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

Write-Host ""
Write-Host "✅ Resources deleted successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Sync the ArgoCD application (it will recreate the resources)"
Write-Host "2. The PVCs (mysql-pvc, redis-pvc) will be reused by the new StatefulSets"
Write-Host "3. Verify with: kubectl get statefulset,pvc -n laravel"

