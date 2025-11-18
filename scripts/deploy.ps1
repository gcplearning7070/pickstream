# Deployment script for Random Names Web Application to GCP (Windows PowerShell)

$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Deploying Random Names Web Application" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

# Check required tools
$tools = @("gcloud", "packer", "terraform")
foreach ($tool in $tools) {
    try {
        $null = Get-Command $tool -ErrorAction Stop
    } catch {
        Write-Host "Error: $tool is not installed" -ForegroundColor Red
        exit 1
    }
}

# Get project root directory
$ProjectRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
if (-not $ProjectRoot) {
    $ProjectRoot = Split-Path -Parent $PSCommandPath
}

# Check if configuration files exist
$packerVars = Join-Path $ProjectRoot "packer\variables.pkrvars.hcl"
if (-not (Test-Path $packerVars)) {
    Write-Host "Error: Packer variables file not found" -ForegroundColor Red
    Write-Host "Please copy packer\variables.pkrvars.hcl.example to packer\variables.pkrvars.hcl and configure it" -ForegroundColor Yellow
    exit 1
}

$terraformVars = Join-Path $ProjectRoot "terraform\terraform.tfvars"
if (-not (Test-Path $terraformVars)) {
    Write-Host "Error: Terraform variables file not found" -ForegroundColor Red
    Write-Host "Please copy terraform\terraform.tfvars.example to terraform\terraform.tfvars and configure it" -ForegroundColor Yellow
    exit 1
}

# Step 1: Build application
Write-Host ""
Write-Host "Step 1: Building application..." -ForegroundColor Yellow
Set-Location $ProjectRoot
& .\scripts\build.ps1
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Step 2: Build Packer image
Write-Host ""
Write-Host "Step 2: Building custom GCP image with Packer..." -ForegroundColor Yellow
Set-Location (Join-Path $ProjectRoot "packer")
packer init image.pkr.hcl
packer build -var-file="variables.pkrvars.hcl" image.pkr.hcl
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

# Step 3: Deploy with Terraform
Write-Host ""
Write-Host "Step 3: Deploying infrastructure with Terraform..." -ForegroundColor Yellow
Set-Location (Join-Path $ProjectRoot "terraform")
terraform init
terraform plan

Write-Host ""
$Confirm = Read-Host "Do you want to apply these changes? (yes/no)"

if ($Confirm -eq "yes") {
    terraform apply -auto-approve
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    
    Write-Host ""
    Write-Host "=========================================" -ForegroundColor Green
    Write-Host "Deployment successful!" -ForegroundColor Green
    Write-Host "=========================================" -ForegroundColor Green
    terraform output
} else {
    Write-Host "Deployment cancelled" -ForegroundColor Yellow
    exit 0
}
