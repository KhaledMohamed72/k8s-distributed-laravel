# PowerShell script to clean up old PVCs from volumeClaimTemplates
# These PVCs are no longer needed since we're using standalone PVCs

$ErrorActionPreference = "Continue"

Write-Host "Cleaning up old PVCs from volumeClaimTemplates..." -ForegroundColor Yellow

# Delete old PVCs created by volumeClaimTemplates
kubectl delete pvc mysql-storage-mysql-0 -n laravel --ignore-not-found=true
kubectl delete pvc redis-storage-redis-0 -n laravel --ignore-not-found=true

Write-Host ""
Write-Host "✅ Old PVCs deleted!" -ForegroundColor Green
Write-Host ""
Write-Host "Note: The standalone PVCs (mysql-pvc, redis-pvc) will bind to PVs after syncing ArgoCD" -ForegroundColor Cyan

