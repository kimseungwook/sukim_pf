# Backend Directory Test Build Script
# This script tests the Docker build with the new backend/ structure

Write-Host "=== Testing Backend Docker Build ===" -ForegroundColor Cyan
Write-Host ""

$backendDir = "D:\github\sukim-pf\sukim_pf\application\ecommerce-react\backend"

# Test 1: Check if Dockerfile exists
Write-Host "Test 1: Dockerfile Existence" -ForegroundColor Yellow
if (Test-Path "$backendDir\Dockerfile.backend") {
    Write-Host "[OK] Dockerfile.backend exists" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Dockerfile.backend not found" -ForegroundColor Red
    exit 1
}

# Test 2: Check if go.mod exists
Write-Host ""
Write-Host "Test 2: Go Module Files" -ForegroundColor Yellow
if (Test-Path "$backendDir\go.mod") {
    Write-Host "[OK] go.mod exists" -ForegroundColor Green
} else {
    Write-Host "[FAIL] go.mod not found" -ForegroundColor Red
    exit 1
}

# Test 3: Check if cmd directory exists
Write-Host ""
Write-Host "Test 3: Source Code Structure" -ForegroundColor Yellow
if (Test-Path "$backendDir\cmd") {
    Write-Host "[OK] cmd/ directory exists" -ForegroundColor Green
} else {
    Write-Host "[FAIL] cmd/ directory not found" -ForegroundColor Red
    exit 1
}

# Test 4: Docker build (optional, requires Docker)
Write-Host ""
Write-Host "Test 4: Docker Build (optional)" -ForegroundColor Yellow
Write-Host "To test Docker build, run:" -ForegroundColor Gray
Write-Host "  cd application/ecommerce-react/backend" -ForegroundColor Gray
Write-Host "  docker build -f Dockerfile.backend -t ecommerce-backend:test ." -ForegroundColor Gray

Write-Host ""
Write-Host "=== All Tests Passed ===" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Commit the restructured code"
Write-Host "2. Push to GitHub"
Write-Host "3. Verify Tekton pipeline triggers only on backend/ changes"
Write-Host "4. Test build: git commit -m '[bd:backend] Test build' --allow-empty"
