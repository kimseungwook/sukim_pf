# Ecommerce Backend Directory Restructuring Script
# This script moves Go backend files into the backend/ subdirectory

Write-Host "=== Ecommerce Backend Directory Restructuring ===" -ForegroundColor Cyan
Write-Host ""

$sourceDir = "D:\github\sukim-pf\sukim_pf\application\ecommerce-react"
$backendDir = "$sourceDir\backend"

# Ensure backend directory exists
if (-not (Test-Path $backendDir)) {
    Write-Host "Creating backend directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $backendDir | Out-Null
}

# Files and directories to move to backend/
$itemsToMove = @(
    "cmd",
    "internals",
    "pkgs",
    "utils",
    "configs",
    "policy",
    "db",
    "docs",
    "go.mod",
    "go.sum",
    "Dockerfile.backend",
    "entrypoint.sh",
    "app.example.env",
    ".air.toml",
    "Makefile"
)

Write-Host "Moving files to backend/..." -ForegroundColor Yellow
foreach ($item in $itemsToMove) {
    $sourcePath = Join-Path $sourceDir $item
    $destPath = Join-Path $backendDir $item
    
    if (Test-Path $sourcePath) {
        # Check if destination already exists
        if (Test-Path $destPath) {
            Write-Host "  [SKIP] $item (already exists in backend/)" -ForegroundColor Gray
        } else {
            try {
                Move-Item -Path $sourcePath -Destination $destPath -ErrorAction Stop
                Write-Host "  [MOVE] $item" -ForegroundColor Green
            } catch {
                Write-Host "  [FAIL] $item : $($_.Exception.Message)" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "  [SKIP] $item (not found)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "=== Verification ===" -ForegroundColor Cyan

# Verify backend structure
if (Test-Path "$backendDir\go.mod") {
    Write-Host "[OK] go.mod found in backend/" -ForegroundColor Green
} else {
    Write-Host "[WARN] go.mod not found in backend/" -ForegroundColor Red
}

if (Test-Path "$backendDir\cmd") {
    Write-Host "[OK] cmd/ directory found in backend/" -ForegroundColor Green
} else {
    Write-Host "[WARN] cmd/ directory not found in backend/" -ForegroundColor Red
}

if (Test-Path "$backendDir\Dockerfile.backend") {
    Write-Host "[OK] Dockerfile.backend found in backend/" -ForegroundColor Green
} else {
    Write-Host "[WARN] Dockerfile.backend not found in backend/" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Remaining in ecommerce-react/ ===" -ForegroundColor Cyan
Get-ChildItem $sourceDir -Directory | Where-Object { $_.Name -ne "backend" } | Select-Object Name | Format-Table

Write-Host ""
Write-Host "=== Next Steps ===" -ForegroundColor Cyan
Write-Host "1. Update Dockerfile.backend COPY paths"
Write-Host "2. Update Tekton values.yaml dockerfile path"
Write-Host "3. Update EventListener path filter"
Write-Host "4. Test local Docker build"
Write-Host "5. Commit and push changes"
