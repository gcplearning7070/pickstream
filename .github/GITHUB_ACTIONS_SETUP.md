# GitHub Actions Setup Guide

This guide will help you set up GitHub Actions for automated CI/CD deployment to GCP.

## Prerequisites

- GitHub repository for your code
- GCP account with billing enabled
- GCP project created

## Step-by-Step Setup

### 1. Create GCP Service Account

```bash
# Set your project ID
export PROJECT_ID="your-gcp-project-id"

# Create service account for GitHub Actions
gcloud iam service-accounts create github-actions \
    --display-name="GitHub Actions Service Account" \
    --description="Service account for GitHub Actions CI/CD" \
    --project=$PROJECT_ID
```

### 2. Grant Required Permissions

```bash
# Compute Admin (to manage VMs and images)
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/compute.admin"

# Storage Admin (for storing state files)
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

# Service Account User (to act as service account)
gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member="serviceAccount:github-actions@${PROJECT_ID}.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"
```

### 3. Create and Download Service Account Key

```bash
# Create key
gcloud iam service-accounts keys create ~/github-actions-key.json \
    --iam-account=github-actions@${PROJECT_ID}.iam.gserviceaccount.com

# View the key (you'll need this for GitHub)
cat ~/github-actions-key.json
```

⚠️ **Important**: Keep this key secure! Don't commit it to your repository.

### 4. Configure GitHub Secrets

Go to your GitHub repository:
1. Click **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**

Add the following secrets:

#### `GCP_SA_KEY`
- Name: `GCP_SA_KEY`
- Value: Entire contents of `github-actions-key.json` file

#### `GCP_PROJECT_ID`
- Name: `GCP_PROJECT_ID`
- Value: Your GCP project ID (e.g., `my-project-123456`)

### 5. Configure GitHub Variables (Optional)

Click on **Variables** tab and add:

#### `GCP_REGION`
- Name: `GCP_REGION`
- Value: `us-central1` (or your preferred region)

#### `GCP_ZONE`
- Name: `GCP_ZONE`
- Value: `us-central1-a` (or your preferred zone)

### 6. Enable Required GCP APIs

```bash
# Enable Compute Engine API
gcloud services enable compute.googleapis.com --project=$PROJECT_ID

# Enable Cloud Resource Manager API
gcloud services enable cloudresourcemanager.googleapis.com --project=$PROJECT_ID

# Enable IAM API
gcloud services enable iam.googleapis.com --project=$PROJECT_ID
```

### 7. Test the Workflows

#### Test Build Workflow
1. Push code to `main` or `develop` branch
2. Go to Actions tab in GitHub
3. Check "Build and Test" workflow status

#### Test Deployment Workflow
1. Go to Actions tab
2. Select "Deploy to GCP"
3. Click "Run workflow"
4. Select branch and environment
5. Click "Run workflow"

## Workflow Descriptions

### build.yml
- **Trigger**: Push or PR to main/develop
- **Purpose**: Build and test the application
- **Outputs**: WAR file artifact

### deploy-gcp.yml
- **Trigger**: Push to main or manual dispatch
- **Purpose**: Full deployment to GCP
- **Steps**:
  1. Build application
  2. Create Packer image
  3. Deploy with Terraform
  4. Output application URL

### pr-checks.yml
- **Trigger**: Pull requests
- **Purpose**: Validate code quality and configs
- **Checks**:
  - Java compilation
  - Tests
  - Terraform validation
  - Packer validation

### cleanup.yml
- **Trigger**: Weekly schedule or manual
- **Purpose**: Delete old Packer images
- **Retention**: Keeps 3 most recent images

## Troubleshooting

### "Permission denied" errors
- Verify service account has all required roles
- Check that APIs are enabled
- Ensure service account key is valid

### "Image not found" errors
- Run Packer workflow first to create the image
- Check that `image_family` matches in Terraform

### Workflow fails at Terraform step
- Verify `GCP_PROJECT_ID` secret is correct
- Check that Packer image exists
- Review Terraform state

### Authentication errors
- Verify `GCP_SA_KEY` secret is properly formatted JSON
- Ensure service account exists: `gcloud iam service-accounts list`

## Security Best Practices

1. **Rotate Keys Regularly**: Create new service account keys periodically
2. **Principle of Least Privilege**: Only grant necessary permissions
3. **Use Environments**: Set up GitHub Environments for staging/production
4. **Review Logs**: Regularly check workflow logs for suspicious activity
5. **Enable Branch Protection**: Require PR reviews before merging to main

## Cost Optimization

- Cleanup workflow removes old images automatically
- Consider using cheaper machine types in `terraform.tfvars`
- Stop instances when not needed
- Monitor GCP billing alerts

## Next Steps

1. Set up branch protection rules
2. Configure GitHub Environments for staging/production
3. Add approval gates for production deployments
4. Set up monitoring and alerting
5. Configure Terraform remote state in GCS

## Cleanup

To remove the service account:

```bash
# Delete service account
gcloud iam service-accounts delete \
    github-actions@${PROJECT_ID}.iam.gserviceaccount.com \
    --project=$PROJECT_ID

# Remove local key file
rm ~/github-actions-key.json
```
