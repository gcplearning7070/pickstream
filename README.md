# Random Names Web Application

A simple Java web application that randomly displays names from a configurable list. Built with Java Servlets and deployed on GCP using Packer and Terraform.

## 🚀 Features

- **Random Name Display**: Click a button to display a random name from the list
- **Add Names**: Dynamically add new names to the list via the web interface
- **Modern UI**: Responsive design with gradient styling
- **REST API**: JSON-based API for programmatic access

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- **Java 11** or higher
- **Maven 3.6+**
- **Packer 1.8+**
- **Terraform 1.0+**
- **Google Cloud SDK** (gcloud CLI)
- A **GCP Project** with billing enabled

## 🏗️ Project Structure

```
Java-webapp/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/example/webapp/
│       │       └── RandomNameServlet.java
│       └── webapp/
│           ├── index.html
│           └── WEB-INF/
│               └── web.xml
├── packer/
│   ├── image.pkr.hcl
│   └── variables.pkrvars.hcl.example
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── compute.tf
│   ├── outputs.tf
│   └── terraform.tfvars.example
├── scripts/
│   ├── build.sh
│   ├── deploy.sh
│   └── build.ps1
├── pom.xml
└── README.md
```

## 🛠️ Local Development

### Build the Application

```bash
mvn clean package
```

The WAR file will be created at `target/random-names.war`

### Run Locally with Tomcat

1. Install Tomcat 9 locally
2. Copy the WAR file to Tomcat's webapps directory
3. Start Tomcat
4. Access the application at: `http://localhost:8080/random-names`

## 🔄 GitHub Actions CI/CD

This project includes GitHub Actions workflows for automated building, testing, and deployment.

### Workflows

1. **Build and Test** (`.github/workflows/build.yml`)
   - Triggers on push/PR to `main` or `develop` branches
   - Builds the application with Maven
   - Runs tests
   - Uploads WAR artifact

2. **Deploy to GCP** (`.github/workflows/deploy-gcp.yml`)
   - Triggers on push to `main` or manual workflow dispatch
   - Builds Packer image
   - Deploys infrastructure with Terraform
   - Outputs application URL

3. **PR Checks** (`.github/workflows/pr-checks.yml`)
   - Validates code, Terraform, and Packer configs
   - Runs on all pull requests

4. **Cleanup Old Images** (`.github/workflows/cleanup.yml`)
   - Runs weekly (Sundays at 2 AM UTC)
   - Keeps only the 3 most recent Packer images
   - Can be triggered manually

### GitHub Secrets Setup

Configure these secrets in your GitHub repository (Settings → Secrets and variables → Actions):

#### Required Secrets:
- `GCP_SA_KEY`: GCP service account JSON key with permissions:
  - Compute Admin
  - Storage Admin
  - Service Account User

```bash
# Create service account
gcloud iam service-accounts create github-actions \
    --display-name="GitHub Actions"

# Grant permissions
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/compute.admin"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/storage.admin"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
    --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
    --role="roles/iam.serviceAccountUser"

# Create and download key
gcloud iam service-accounts keys create key.json \
    --iam-account=github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com

# Copy the contents of key.json to GCP_SA_KEY secret
```

- `GCP_PROJECT_ID`: Your GCP project ID

#### Optional Variables:
- `GCP_REGION`: GCP region (default: `us-central1`)
- `GCP_ZONE`: GCP zone (default: `us-central1-a`)

### Manual Deployment

To trigger a manual deployment:

1. Go to Actions tab in GitHub
2. Select "Deploy to GCP" workflow
3. Click "Run workflow"
4. Choose environment and branch
5. Click "Run workflow"

### Workflow Status Badges

Add these to the top of your README:

```markdown
![Build](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/build.yml/badge.svg)
![Deploy](https://github.com/YOUR_USERNAME/YOUR_REPO/actions/workflows/deploy-gcp.yml/badge.svg)
```

## ☁️ GCP Deployment

### Step 1: Configure GCP

```bash
# Authenticate with GCP
gcloud auth login
gcloud auth application-default login

# Set your project
gcloud config set project YOUR_PROJECT_ID

# Enable required APIs
gcloud services enable compute.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```

### Step 2: Build Custom Image with Packer

```bash
# Navigate to the packer directory
cd packer

# Copy and configure variables
cp variables.pkrvars.hcl.example variables.pkrvars.hcl
# Edit variables.pkrvars.hcl with your project_id

# Initialize Packer
packer init image.pkr.hcl

# Build the image
packer build -var-file="variables.pkrvars.hcl" image.pkr.hcl
```

This creates a custom GCP image with:
- Ubuntu 22.04 LTS
- Java 11
- Maven
- Tomcat 9
- Your web application pre-deployed

### Step 3: Deploy Infrastructure with Terraform

```bash
# Navigate to the terraform directory
cd ../terraform

# Copy and configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your project_id and preferences

# Initialize Terraform
terraform init

# Preview the changes
terraform plan

# Apply the configuration
terraform apply
```

This creates:
- VPC network
- Firewall rules (SSH, HTTP, Tomcat)
- Static external IP
- Compute instance with your custom image

### Step 4: Access Your Application

After Terraform completes, it will output the application URL:

```
webapp_url = "http://XX.XX.XX.XX:8080/random-names"
```

Open this URL in your browser to access your application!

## 🔧 Configuration

### Modify Default Names

Edit `src/main/java/com/example/webapp/RandomNameServlet.java` and update the `init()` method:

```java
@Override
public void init() throws ServletException {
    names.add("Your Name 1");
    names.add("Your Name 2");
    // Add more names...
}
```

### Change Machine Type

Edit `terraform/terraform.tfvars`:

```hcl
machine_type = "e2-small"  # or e2-medium, e2-standard-2, etc.
```

### Change Region/Zone

Edit `terraform/terraform.tfvars`:

```hcl
region = "us-west1"
zone   = "us-west1-a"
```

## 🔄 Update Application

To deploy an updated version:

1. Make your code changes
2. Rebuild the Packer image:
   ```bash
   cd packer
   packer build -var-file="variables.pkrvars.hcl" image.pkr.hcl
   ```
3. Recreate the instance:
   ```bash
   cd ../terraform
   terraform taint google_compute_instance.webapp_instance
   terraform apply
   ```

## 📡 API Endpoints

### Get Random Name
```
GET /random-names/api/random-name
```

Response:
```json
{
  "name": "Alice Johnson"
}
```

### Add New Name
```
POST /random-names/api/random-name
Content-Type: application/x-www-form-urlencoded

name=John+Doe
```

Response:
```json
{
  "success": true,
  "message": "Name added successfully"
}
```

## 🧹 Cleanup

To destroy all GCP resources:

```bash
cd terraform
terraform destroy
```

To delete the custom image:

```bash
gcloud compute images list --filter="family:random-names-webapp"
gcloud compute images delete IMAGE_NAME
```

## 💰 Cost Estimation

Approximate monthly costs (us-central1):
- **e2-medium instance**: ~$24/month
- **20GB Standard persistent disk**: ~$0.80/month
- **Static IP**: ~$7/month (when instance is running)
- **Egress traffic**: Variable based on usage

**Total**: ~$32/month

## 🔒 Security Considerations

For production deployments, consider:

1. **Restrict SSH access**: Limit source IPs in firewall rules
2. **Use HTTPS**: Set up Cloud Load Balancer with SSL certificate
3. **Enable Cloud Armor**: Protect against DDoS attacks
4. **Use Secret Manager**: Store sensitive configuration
5. **Regular updates**: Keep OS and Java packages updated
6. **Monitoring**: Enable Cloud Monitoring and Logging

## 📝 Troubleshooting

### Application not accessible
1. Check firewall rules: `gcloud compute firewall-rules list`
2. Verify instance is running: `gcloud compute instances list`
3. Check Tomcat status: `gcloud compute ssh INSTANCE_NAME --command "sudo systemctl status tomcat9"`

### Build fails
1. Ensure Java 11 is installed: `java -version`
2. Verify Maven is working: `mvn -version`
3. Check for port conflicts

### Packer build fails
1. Verify GCP credentials: `gcloud auth list`
2. Check project ID is correct
3. Ensure required APIs are enabled

## 📄 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!
