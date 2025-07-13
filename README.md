Azure Redis Cache Terraform Deployment

This repository provisions Azure Redis Cache infrastructure using Terraform with modular structure and GitHub Actions for CI/CD automation. It supports multiple environments (dev, prod) and integrates Infracost for cost estimation.

 Features

Deploys Azure Redis Cache with configurable parameters

Environment-based configuration (dev, prod)

Modular Terraform structure

GitHub Actions pipeline for:

Terraform init/plan/apply

Cost estimation using Infracost

CI/CD triggers on main(manual) and stage(automatic) branches

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
    cache/
      main.tf
      outputs.tf
      variables.tf
.github/
  workflows/
    deploy.yml
```

##  Required Secrets in GitHub

In your GitHub repo, go to **Settings → Environments → prod and dev->add Environment secrets** and add:

1.AZURE_CREDENTIALS  and the value is in Json format

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

In your GitHub repo, go to **Settings → Secrets & variables → Actions->New Repositorysecrets** and add

2.INFRACOST_API_KEY  value get from the infracost.io site under Organization settings->API Token

# Environments
We need to add total four environments that is dev,prod and dev-plan,prod-plan. to avoid manuall reviewer approval for stage branch plan pipeline I used these two envronments(dev-plan and prod-plan) here we are not selecting any reviewer under deployment reviewer.

# Add Collaborators
Go to your repo → Settings → Collaborators

Click "Invite a collaborator"

Enter your teammate’s GitHub username

Choose appropriate access (usually Write or Admin)

Send invite

Note: If you're the owner, you cannot add yourself — you already have full access.

# Add a GitHub Environment

Go to Settings → Environments

Click "New environment", name it dev

Under "Deployment protection rules", click "Required reviewers"

Add your GitHub username (or a teammate)
Click Save

This will enforce manual approval before applying infrastructure.

# Workflow
in deployment.yml file choose the env either dev or prod and dev-plan or prod-plan under plan pipeline
example:
environment: ${{ github.event.inputs.environment ||'dev-plan'}}
env:
      ENV: ${{ github.event.inputs.environment || 'dev' }}

for the Apply pipeline  :
example
 environment: ${{ github.event.inputs.environment || 'dev' }}
    defaults:
      run:
        working-directory: terraform/environments/${{ github.event.inputs.environment || 'dev' }}


 Trigger on stage branch

Automatically runs terraform init, plan, and Infracost report

Skips apply step (for preview only)

 Trigger on main branch (Manual Approval)

Go to Actions → Terraform Azure Psql DB CI/CD → Run workflow

Select the envronment prod or dev

Enter input yes

Waits for approval (based on environment reviewers)

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
 
 