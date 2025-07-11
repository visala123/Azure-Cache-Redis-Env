Azure Redis Cache Terraform Deployment

This repository provisions Azure Redis Cache infrastructure using Terraform with modular structure and GitHub Actions for CI/CD automation. It supports multiple environments (dev, prod) and integrates Infracost for cost estimation.

 Features

Deploys Azure Redis Cache with configurable parameters

Environment-based configuration (dev, prod)

Modular Terraform structure

GitHub Actions pipeline for:

Terraform init/plan/apply

Cost estimation using Infracost

CI/CD triggers on main and stage branches

## Prerequisites
Create a Remote Backend in Azure (Portal Steps)
Step 1: Create Resource Group
Go to Azure Portal

Search for “Resource groups”

Click “+ Create”

Name: rg-terraform-state

Region: East US (or your preferred)

Click Review + Create → Create

 Step 2: Create Storage Account
Search “Storage accounts”

Click “+ Create”

Resource Group: rg-terraform-state

Storage account name: tfstatestorage1234 (must be globally unique)

Region: Same as above

Performance: Standard, Redundancy: LRS

Click Review + Create → Create

 Step 3: Create Blob Container
Open the storage account you just created

In the left menu, click “Containers”

Click “+ Container”

Name: tfstate, Public access level: Private (no anonymous access)

Click Create

Update backend.tf in your environment folders:

resource_group_name  = "rg-terraform-state"
storage_account_name = "tfstatestorage1234"
container_name       = "tfstate"



 ## Project Structure

```
terraform/
  environments/
    dev/
      backend.tf
      main.tf
      variables.tf
      terraform.tfvars
    prod/
      backend.tf
      main.tf
      variables.tf
      terraform.tfvars
  modules/
    cosmosdb/
      main.tf
      outputs.tf
      variables.tf
.github/
  workflows/
    deploy.yml
```

##  Required Secrets in GitHub

In your GitHub repo, go to **Settings → Secrets and Variables → Actions** and add:

AZURE_CREDENTIALS  and the value is in Json format

```
{
  "clientId": "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx",
  "clientSecret": "your-very-secure-client-secret",
  "tenantId": "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy",
  "subscriptionId": "zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz"
}
```

These are required for the GitHub Actions workflow to authenticate with Azure.
How you get these : in shell run the command :
```
# az ad sp create-for-rbac --name "<App registration name(Service Principal)>" --role Contributor --scopes /subscriptions/$(az account show --query id -o tsv) --sdk-auth
```
# Add Collaborators
Go to your repo → Settings → Collaborators
Click "Invite a collaborator"
Enter your teammate’s GitHub username
Choose appropriate access (usually Write or Admin)
Send invite
Note: If you're the owner, you cannot add yourself — you already have full access.
# Add a GitHub Environment
Go to Settings → Environments
Click "New environment", name it dev-approval
Under "Deployment protection rules", click "Required reviewers"
Add your GitHub username (or a teammate)
Click Save
This will enforce manual approval before applying infrastructure.

# Workflow
 Trigger on stage branch
Automatically runs terraform init, plan, and Infracost report

Skips apply step (for preview only)

 Trigger on main branch (Manual Approval)
Go to Actions → Terraform Redis CI/CD → Run workflow

Enter input yes

Terraform plan runs

Waits for approval (based on environment reviewers)

Once approved, resources are deployed

# Outputs
redis_host_name – The Redis hostname

redis_ssl_port – SSL port to connect securely

##  Cleanup
```terminal
terraform init
terraform destroy 
```

# References
Azure Cache for Redis - Terraform Docs

https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/redis_cache#Microsoft.Cache-1
 
 