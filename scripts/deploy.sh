#!/bin/bash

# Deployment script for Random Names Web Application to GCP

set -e

echo "========================================="
echo "Deploying Random Names Web Application"
echo "========================================="

# Check required tools
command -v gcloud >/dev/null 2>&1 || { echo "Error: gcloud CLI is not installed"; exit 1; }
command -v packer >/dev/null 2>&1 || { echo "Error: Packer is not installed"; exit 1; }
command -v terraform >/dev/null 2>&1 || { echo "Error: Terraform is not installed"; exit 1; }

# Get project root directory
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Check if configuration files exist
if [ ! -f "$PROJECT_ROOT/packer/variables.pkrvars.hcl" ]; then
    echo "Error: Packer variables file not found"
    echo "Please copy packer/variables.pkrvars.hcl.example to packer/variables.pkrvars.hcl and configure it"
    exit 1
fi

if [ ! -f "$PROJECT_ROOT/terraform/terraform.tfvars" ]; then
    echo "Error: Terraform variables file not found"
    echo "Please copy terraform/terraform.tfvars.example to terraform/terraform.tfvars and configure it"
    exit 1
fi

# Step 1: Build application
echo ""
echo "Step 1: Building application..."
cd "$PROJECT_ROOT"
bash scripts/build.sh

# Step 2: Build Packer image
echo ""
echo "Step 2: Building custom GCP image with Packer..."
cd "$PROJECT_ROOT/packer"
packer init image.pkr.hcl
packer build -var-file="variables.pkrvars.hcl" image.pkr.hcl

# Step 3: Deploy with Terraform
echo ""
echo "Step 3: Deploying infrastructure with Terraform..."
cd "$PROJECT_ROOT/terraform"
terraform init
terraform plan
echo ""
read -p "Do you want to apply these changes? (yes/no): " CONFIRM

if [ "$CONFIRM" = "yes" ]; then
    terraform apply -auto-approve
    
    echo ""
    echo "========================================="
    echo "Deployment successful!"
    echo "========================================="
    terraform output
else
    echo "Deployment cancelled"
    exit 0
fi
