# PickStream - Command Line Cheat Sheet

## 📋 Table of Contents
- [Git Commands](#git-commands)
- [Maven Commands](#maven-commands)
- [Packer Commands](#packer-commands)
- [Terraform Commands](#terraform-commands)
- [GCloud CLI Commands](#gcloud-cli-commands)
- [Tomcat Commands](#tomcat-commands)
- [SonarCloud Commands](#sonarcloud-commands)
- [Snyk Commands](#snyk-commands)
- [Useful Combinations](#useful-combinations)

---

## Git Commands

### Repository Setup
```bash
# Initialize repository
git init

# Clone repository
git clone https://github.com/gcpt0801/pickstream.git

# Check repository status
git status

# View remote URLs
git remote -v
```

### Branch Management
```bash
# List all branches
git branch -a

# Create new branch
git checkout -b feature-branch

# Switch branches
git checkout main

# Delete local branch
git branch -d feature-branch

# Delete remote branch
git push origin --delete feature-branch

# View branch protection rules (via GitHub UI or API)
gh api repos/gcpt0801/pickstream/branches/main/protection
```

### Staging & Committing
```bash
# Add all changes
git add .

# Add specific file
git add path/to/file

# Commit with message
git commit -m "Your commit message"

# Amend last commit
git commit --amend -m "Updated message"

# Stage and commit in one command
git commit -am "Message for tracked files only"
```

### Push & Pull
```bash
# Push to remote
git push origin main

# Pull latest changes
git pull origin main

# Force push (use with caution)
git push --force origin main

# Pull with rebase
git pull --rebase origin main
```

### History & Logs
```bash
# View commit history
git log

# View compact history
git log --oneline

# View last 5 commits
git log -5

# View file history
git log -- path/to/file

# View changes in commit
git show <commit-hash>

# View who changed what
git blame path/to/file
```

### Diff & Changes
```bash
# View unstaged changes
git diff

# View staged changes
git diff --cached

# Compare branches
git diff main..feature-branch

# Compare specific files
git diff HEAD path/to/file
```

### Stash
```bash
# Stash changes
git stash

# List stashes
git stash list

# Apply last stash
git stash apply

# Apply specific stash
git stash apply stash@{1}

# Drop stash
git stash drop
```

### Tags
```bash
# Create tag
git tag v1.0.0

# Push tag to remote
git push origin v1.0.0

# List tags
git tag -l

# Delete tag
git tag -d v1.0.0
git push origin :refs/tags/v1.0.0
```

---

## Maven Commands

### Build & Package
```bash
# Clean build directory
mvn clean

# Compile source code
mvn compile

# Run tests
mvn test

# Package as WAR
mvn package

# Clean and package
mvn clean package

# Skip tests during build
mvn clean package -DskipTests

# Build with specific profile
mvn clean package -Pproduction
```

### Dependency Management
```bash
# Display dependency tree
mvn dependency:tree

# Download dependencies
mvn dependency:resolve

# Check for updates
mvn versions:display-dependency-updates

# Purge local repository
mvn dependency:purge-local-repository
```

### Testing
```bash
# Run all tests
mvn test

# Run specific test class
mvn test -Dtest=RandomNameServletTest

# Run specific test method
mvn test -Dtest=RandomNameServletTest#testDoGet

# Run tests with coverage
mvn clean test jacoco:report
```

### Analysis & Reports
```bash
# Generate site documentation
mvn site

# Run checkstyle
mvn checkstyle:check

# Find bugs
mvn findbugs:findbugs

# Generate test coverage report
mvn jacoco:report
```

### Useful Options
```bash
# Debug mode
mvn -X clean package

# Offline mode
mvn -o package

# Update snapshots
mvn -U clean package

# Show version
mvn --version
```

---

## Packer Commands

### Validation & Formatting
```bash
# Navigate to packer directory
cd packer

# Validate template
packer validate image.pkr.hcl

# Format template
packer fmt image.pkr.hcl

# Initialize plugins
packer init image.pkr.hcl
```

### Building Images
```bash
# Build image
packer build image.pkr.hcl

# Build with variable file
packer build -var-file=variables.pkr.hcl image.pkr.hcl

# Build with specific variables
packer build -var 'project_id=gcp-terraform-demo-474514' image.pkr.hcl

# Force build (overwrite existing)
packer build -force image.pkr.hcl

# Debug mode
packer build -debug image.pkr.hcl

# Only specific build
packer build -only=googlecompute.webapp image.pkr.hcl
```

### Inspection
```bash
# Inspect template
packer inspect image.pkr.hcl

# Show machine-readable output
packer build -machine-readable image.pkr.hcl
```

---

## Terraform Commands

### Initialization
```bash
# Navigate to terraform directory
cd terraform

# Initialize (download providers)
terraform init

# Initialize and upgrade providers
terraform init -upgrade

# Reconfigure backend
terraform init -reconfigure

# Initialize without backend
terraform init -backend=false
```

### Planning & Applying
```bash
# Show execution plan
terraform plan

# Plan with variable file
terraform plan -var-file=terraform.tfvars

# Plan and save to file
terraform plan -out=tfplan

# Apply changes
terraform apply

# Apply without confirmation
terraform apply -auto-approve

# Apply saved plan
terraform apply tfplan

# Apply with specific target
terraform apply -target=google_compute_instance.webapp
```

### State Management
```bash
# Show current state
terraform show

# List resources in state
terraform state list

# Show specific resource
terraform state show google_compute_instance.webapp

# Pull remote state
terraform state pull

# Remove resource from state
terraform state rm google_compute_instance.webapp

# Move resource in state
terraform state mv old_name new_name

# Refresh state
terraform refresh
```

### Destruction
```bash
# Destroy all resources
terraform destroy

# Destroy without confirmation
terraform destroy -auto-approve

# Destroy specific resource
terraform destroy -target=google_compute_instance.webapp

# Preview destruction
terraform plan -destroy
```

### Validation & Formatting
```bash
# Validate configuration
terraform validate

# Format files
terraform fmt

# Format recursively
terraform fmt -recursive

# Check formatting
terraform fmt -check
```

### Workspace Management
```bash
# List workspaces
terraform workspace list

# Create workspace
terraform workspace new dev

# Switch workspace
terraform workspace select dev

# Delete workspace
terraform workspace delete dev
```

### Output
```bash
# Show all outputs
terraform output

# Show specific output
terraform output instance_ip

# Output as JSON
terraform output -json
```

---

## GCloud CLI Commands

### Authentication & Configuration
```bash
# Login to GCP
gcloud auth login

# Set active project
gcloud config set project gcp-terraform-demo-474514

# Set default zone
gcloud config set compute/zone us-central1-a

# Set default region
gcloud config set compute/region us-central1

# View current configuration
gcloud config list

# Activate service account
gcloud auth activate-service-account --key-file=key.json
```

### Compute Instances
```bash
# List instances
gcloud compute instances list

# Describe instance
gcloud compute instances describe pickstream-instance --zone=us-central1-a

# Start instance
gcloud compute instances start pickstream-instance --zone=us-central1-a

# Stop instance
gcloud compute instances stop pickstream-instance --zone=us-central1-a

# Delete instance
gcloud compute instances delete pickstream-instance --zone=us-central1-a --quiet

# SSH into instance
gcloud compute ssh pickstream-instance --zone=us-central1-a

# View instance logs
gcloud compute instances get-serial-port-output pickstream-instance --zone=us-central1-a
```

### Images
```bash
# List images
gcloud compute images list

# List images in specific family
gcloud compute images list --filter="family:pickstream"

# Describe image
gcloud compute images describe IMAGE_NAME

# Delete image
gcloud compute images delete IMAGE_NAME --quiet

# Delete old images (keep latest)
gcloud compute images list --filter="family:pickstream" --format="value(name)" | tail -n +2 | xargs -I {} gcloud compute images delete {} --quiet
```

### Firewall Rules
```bash
# List firewall rules
gcloud compute firewall-rules list

# Describe firewall rule
gcloud compute firewall-rules describe allow-ssh

# Delete firewall rule
gcloud compute firewall-rules delete allow-ssh --quiet

# Create firewall rule
gcloud compute firewall-rules create allow-http --allow=tcp:80 --network=webapp-network
```

### Networks
```bash
# List networks
gcloud compute networks list

# Describe network
gcloud compute networks describe webapp-network

# Delete network
gcloud compute networks delete webapp-network --quiet

# List subnets
gcloud compute networks subnets list

# Delete subnet
gcloud compute networks subnets delete SUBNET_NAME --region=us-central1 --quiet
```

### Static IPs
```bash
# List addresses
gcloud compute addresses list

# Describe address
gcloud compute addresses describe webapp-ip --region=us-central1

# Delete address
gcloud compute addresses delete webapp-ip --region=us-central1 --quiet
```

### Storage Buckets (for Terraform state)
```bash
# List buckets
gcloud storage buckets list

# Create bucket
gcloud storage buckets create gs://gcp-tftbk --location=us-central1

# View bucket contents
gcloud storage ls gs://gcp-tftbk/pickstream/terraform/state/

# Delete bucket (must be empty)
gcloud storage buckets delete gs://gcp-tftbk
```

### IAM
```bash
# List service accounts
gcloud iam service-accounts list

# Create service account
gcloud iam service-accounts create SERVICE_ACCOUNT_NAME

# Grant roles
gcloud projects add-iam-policy-binding gcp-terraform-demo-474514 --member="serviceAccount:EMAIL" --role="roles/compute.admin"

# Create key
gcloud iam service-accounts keys create key.json --iam-account=EMAIL
```

---

## Tomcat Commands

### Service Management (Ubuntu)
```bash
# Start Tomcat
sudo systemctl start tomcat9

# Stop Tomcat
sudo systemctl stop tomcat9

# Restart Tomcat
sudo systemctl restart tomcat9

# Check status
sudo systemctl status tomcat9

# Enable on boot
sudo systemctl enable tomcat9

# Disable on boot
sudo systemctl disable tomcat9

# View logs
sudo journalctl -u tomcat9 -f
```

### Application Deployment
```bash
# Deploy WAR file
sudo cp pickstream.war /var/lib/tomcat9/webapps/

# Remove application
sudo rm -rf /var/lib/tomcat9/webapps/pickstream*

# Check deployed applications
ls -la /var/lib/tomcat9/webapps/
```

### Log Management
```bash
# View catalina logs
sudo tail -f /var/lib/tomcat9/logs/catalina.out

# View access logs
sudo tail -f /var/lib/tomcat9/logs/localhost_access_log.*.txt

# View application logs
sudo tail -f /var/lib/tomcat9/logs/localhost.*.log

# Clear logs
sudo rm /var/lib/tomcat9/logs/*.log
sudo rm /var/lib/tomcat9/logs/*.txt
```

### Configuration
```bash
# Edit Tomcat configuration
sudo nano /etc/tomcat9/server.xml

# Edit environment variables
sudo nano /etc/default/tomcat9

# Check Java version used by Tomcat
sudo grep JAVA_HOME /etc/default/tomcat9

# View Tomcat version
sudo /usr/share/tomcat9/bin/version.sh
```

---

## SonarCloud Commands

### Using Maven Plugin
```bash
# Run SonarCloud analysis
mvn clean verify sonar:sonar \
  -Dsonar.projectKey=gcpt0801_pickstream \
  -Dsonar.organization=gcpt0801 \
  -Dsonar.host.url=https://sonarcloud.io \
  -Dsonar.token=YOUR_TOKEN

# Analysis with coverage
mvn clean verify sonar:sonar jacoco:report \
  -Dsonar.projectKey=gcpt0801_pickstream \
  -Dsonar.organization=gcpt0801 \
  -Dsonar.host.url=https://sonarcloud.io \
  -Dsonar.token=YOUR_TOKEN
```

### Using SonarScanner CLI
```bash
# Download and install SonarScanner
# Linux/Mac:
curl -L -o sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.8.0.2856-linux.zip
unzip sonar-scanner.zip

# Run analysis
./sonar-scanner-4.8.0.2856-linux/bin/sonar-scanner \
  -Dsonar.projectKey=gcpt0801_pickstream \
  -Dsonar.organization=gcpt0801 \
  -Dsonar.sources=src/main/java \
  -Dsonar.host.url=https://sonarcloud.io \
  -Dsonar.token=YOUR_TOKEN
```

### View Results
```bash
# Open project in browser
open https://sonarcloud.io/project/overview?id=gcpt0801_pickstream

# Using GitHub CLI
gh browse https://sonarcloud.io/project/overview?id=gcpt0801_pickstream
```

---

## Snyk Commands

### Authentication
```bash
# Login to Snyk
snyk auth

# Set token
snyk config set api=YOUR_TOKEN

# Test authentication
snyk test
```

### Testing
```bash
# Test for vulnerabilities
snyk test

# Test with JSON output
snyk test --json

# Test and show all vulnerabilities
snyk test --severity-threshold=low

# Test specific package manager
snyk test --maven
```

### Monitoring
```bash
# Monitor project
snyk monitor

# Monitor with custom project name
snyk monitor --project-name=pickstream

# Monitor with org
snyk monitor --org=YOUR_ORG
```

### Code Analysis
```bash
# Test code (SAST)
snyk code test

# Test code with JSON output
snyk code test --json
```

### Container Scanning
```bash
# Test Docker image
snyk container test IMAGE_NAME

# Monitor container
snyk container monitor IMAGE_NAME
```

### Reporting
```bash
# Generate HTML report
snyk test --json | snyk-to-html -o report.html

# View dependencies
snyk test --print-deps
```

---

## Useful Combinations

### Complete Local Build & Test
```bash
# Full build with tests and analysis
mvn clean verify && \
mvn sonar:sonar -Dsonar.token=YOUR_TOKEN && \
snyk test
```

### Deploy New Version
```bash
# Build, create image, deploy
cd .. && \
mvn clean package && \
cd packer && \
packer build image.pkr.hcl && \
cd ../terraform && \
terraform apply -auto-approve
```

### Quick Redeploy (Skip Image Build)
```bash
# Just destroy and recreate instance
cd terraform && \
terraform destroy -target=google_compute_instance.webapp -auto-approve && \
terraform apply -target=google_compute_instance.webapp -auto-approve
```

### Full Cleanup
```bash
# Clean everything
cd terraform && \
terraform destroy -auto-approve && \
gcloud compute images list --filter="family:pickstream" --format="value(name)" | xargs -I {} gcloud compute images delete {} --quiet && \
cd .. && \
mvn clean
```

### Check Application Health
```bash
# Get instance IP and test
INSTANCE_IP=$(terraform output -raw instance_ip) && \
curl http://$INSTANCE_IP:8080/pickstream/ && \
curl http://$INSTANCE_IP:8080/pickstream/api/random-name
```

### Tail Multiple Logs
```bash
# Monitor Tomcat on remote instance
gcloud compute ssh pickstream-instance --zone=us-central1-a --command="sudo tail -f /var/lib/tomcat9/logs/catalina.out"
```

### Git Workflow for Feature
```bash
# Complete feature workflow
git checkout -b feature/new-feature && \
git add . && \
git commit -m "Add new feature" && \
git push origin feature/new-feature
# Then create PR via GitHub UI
```

### Update Dependencies
```bash
# Maven dependencies
mvn versions:display-dependency-updates && \
mvn versions:use-latest-releases && \
git add pom.xml && \
git commit -m "Update dependencies"
```

### Backup State
```bash
# Pull and backup Terraform state
cd terraform && \
terraform state pull > backup-$(date +%Y%m%d).tfstate && \
gcloud storage cp backup-*.tfstate gs://gcp-tftbk/backups/
```

### Emergency Rollback
```bash
# Rollback to previous image
cd terraform && \
terraform destroy -target=google_compute_instance.webapp -auto-approve && \
# Update variables.tf to use older image, then:
terraform apply -target=google_compute_instance.webapp -auto-approve
```

---

## Environment Variables

### Required for CI/CD
```bash
# GCP
export GCP_PROJECT_ID=gcp-terraform-demo-474514
export GCP_SA_KEY='<service-account-json>'

# SonarCloud
export SONAR_TOKEN=<your-sonar-token>

# Snyk
export SNYK_TOKEN=<your-snyk-token>

# GitHub
export GITHUB_TOKEN=<your-github-token>
```

### Local Development
```bash
# Set Java version
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH

# Maven options
export MAVEN_OPTS="-Xmx1024m"

# Set region
export CLOUDSDK_COMPUTE_REGION=us-central1
export CLOUDSDK_COMPUTE_ZONE=us-central1-a
```

---

## Troubleshooting Commands

### Check Java
```bash
java -version
mvn -version
echo $JAVA_HOME
which java
```

### Check Tomcat
```bash
sudo systemctl status tomcat9
sudo journalctl -u tomcat9 --no-pager -n 50
netstat -tuln | grep 8080
ps aux | grep tomcat
```

### Check GCP Resources
```bash
gcloud compute instances list
gcloud compute firewall-rules list
gcloud compute networks list
gcloud compute addresses list
```

### Check Terraform State
```bash
terraform state list
terraform show
gcloud storage ls gs://gcp-tftbk/pickstream/terraform/state/
```

### Network Testing
```bash
# Test connectivity
curl -v http://INSTANCE_IP:8080/pickstream/
curl -v http://INSTANCE_IP:8080/pickstream/api/random-name

# SSH and check from inside
gcloud compute ssh pickstream-instance --zone=us-central1-a
curl localhost:8080/pickstream/
```

---

## Quick Reference

| Task | Command |
|------|---------|
| Build WAR | `mvn clean package` |
| Run tests | `mvn test` |
| Build Packer image | `packer build image.pkr.hcl` |
| Deploy infrastructure | `terraform apply` |
| Destroy infrastructure | `terraform destroy` |
| List GCP instances | `gcloud compute instances list` |
| SSH to instance | `gcloud compute ssh pickstream-instance` |
| Restart Tomcat | `sudo systemctl restart tomcat9` |
| View logs | `sudo tail -f /var/lib/tomcat9/logs/catalina.out` |
| Run SonarCloud | `mvn sonar:sonar -Dsonar.token=TOKEN` |
| Run Snyk | `snyk test` |
| Git commit & push | `git add . && git commit -m "msg" && git push` |
| Create PR | `gh pr create --title "Title" --body "Body"` |

---

**Pro Tips:**
- Always run `terraform plan` before `apply`
- Use `-auto-approve` only in automation
- Keep state files in GCS for team collaboration
- Use `git status` frequently to track changes
- Enable debug mode (`-X`, `-debug`) when troubleshooting
- Always validate before building (Packer, Terraform)
- Use `--help` flag to explore command options

