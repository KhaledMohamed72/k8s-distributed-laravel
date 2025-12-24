# PowerShell script to delete PVCs so they can be recreated with new storageClassName
# This is needed because storageClassName is immutable in PVCs

$ErrorActionPreference = "Continue"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Deleting PVCs to change storageClassName" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Note: This will delete the data in the PVCs
Write-Host "⚠️  WARNING: This will delete existing PVCs and their data!" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to cancel, or wait 5 seconds to continue..." -ForegroundColor Yellow
Start-Sleep -Seconds 5

# Delete StatefulSets first (they depend on PVCs)
Write-Host "Step 1: Deleting StatefulSets..." -ForegroundColor Yellow
kubectl delete statefulset mysql -n laravel --ignore-not-found=true
kubectl delete statefulset redis -n laravel --ignore-not-found=true
Write-Host "✅ StatefulSets deleted" -ForegroundColor Green
Write-Host ""

# Wait a moment
Start-Sleep -Seconds 2

# Delete PVCs
Write-Host "Step 2: Deleting PVCs..." -ForegroundColor Yellow
kubectl delete pvc mysql-pvc -n laravel --ignore-not-found=true
kubectl delete pvc redis-pvc -n laravel --ignore-not-found=true
Write-Host "✅ PVCs deleted" -ForegroundColor Green
Write-Host ""

# Wait for cleanup
Write-Host "Step 3: Waiting for cleanup..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

# Check status
Write-Host "Step 4: Current PVC status:" -ForegroundColor Yellow
kubectl get pvc -n laravel
Write-Host ""

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "✅ PVCs deleted successfully!" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Sync your ArgoCD application"
Write-Host "2. ArgoCD will recreate PVCs with 'standard' storageClassName"
Write-Host "3. StatefulSets will be recreated and will use the new PVCs"
Write-Host ""
Write-Host "After syncing, verify with:" -ForegroundColor Cyan
Write-Host "  kubectl get pvc -n laravel"
Write-Host "  kubectl get statefulset -n laravel"
Write-Host "==========================================" -ForegroundColor Cyan

