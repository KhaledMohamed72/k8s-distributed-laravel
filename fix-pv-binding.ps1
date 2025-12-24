# PowerShell script to fix PVs stuck in Terminating state
# This releases PVs from old PVCs so they can bind to new ones

$ErrorActionPreference = "Continue"

Write-Host "Fixing PVs stuck in Terminating state..." -ForegroundColor Yellow

# Check if old PVCs exist in default namespace
Write-Host "Checking for old PVCs in default namespace..." -ForegroundColor Cyan
kubectl get pvc mysql-storage-mysql-0 -n default --ignore-not-found=true
kubectl get pvc redis-storage-redis-0 -n default --ignore-not-found=true

# Delete old PVCs in default namespace if they exist
Write-Host ""
Write-Host "Deleting old PVCs in default namespace..." -ForegroundColor Yellow
kubectl delete pvc mysql-storage-mysql-0 -n default --ignore-not-found=true
kubectl delete pvc redis-storage-redis-0 -n default --ignore-not-found=true

# Wait a moment
Start-Sleep -Seconds 2

# Patch PVs to remove finalizers and claim references
Write-Host ""
Write-Host "Patching PVs to release them..." -ForegroundColor Yellow
kubectl patch pv mysql-pv -p '{\"metadata\":{\"finalizers\":null},\"spec\":{\"claimRef\":null}}' 2>$null
kubectl patch pv redis-pv -p '{\"metadata\":{\"finalizers\":null},\"spec\":{\"claimRef\":null}}' 2>$null

# Wait for PVs to be released
Write-Host ""
Write-Host "Waiting for PVs to be released..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Check PV status
Write-Host ""
Write-Host "Current PV status:" -ForegroundColor Cyan
kubectl get pv

Write-Host ""
Write-Host "✅ PVs should now be Available. Sync ArgoCD to bind new PVCs." -ForegroundColor Green

