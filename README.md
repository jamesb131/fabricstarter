# Fabric Starter Terraform Deployment

This project automates the deployment of Azure resources and app registrations for Microsoft Fabric, Power BI, and Graph API using Terraform.

## Features

- Deploys an Azure Resource Group and Key Vault
- Registers Azure AD applications for Power BI, Graph API, and Graph Mail (conditionally)
- Stores application IDs and secrets in Azure Key Vault
- Grants Key Vault access to the deployment identity and a specified admin user
- Optionally deploys Microsoft Fabric Capacity

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.0+
- Azure subscription and permissions to create resources
- Azure AD Global Admin or Application Admin for app registration
- Service Principal or user credentials for Terraform authentication

## Usage

1. **Clone the repository:**
   ```sh
   git clone <repo-url>
   cd fabricstarter
   ```

2. **Configure your user for Git (optional):**
   ```sh
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

3. **Edit `terraform.tfvars`:**
   Set your Azure subscription ID and admin email:
   ```hcl
   subscription_id = "<your-subscription-id>"
   admin_email     = "<your-admin-email>"
   ```
   Adjust other variables as needed.

4. **Initialize Terraform:**
   ```sh
   terraform init
   ```

5. **Review the planned changes:**
   ```sh
   terraform plan
   ```

6. **Apply the deployment:**
   ```sh
   terraform apply
   ```

## Variables

See [`variables.tf`](variables.tf) for all configurable options. Key variables include:

- `subscription_id` (required): Azure Subscription ID
- `admin_email` (required): Azure AD user principal name for admin
- `resource_group_name`, `location`, `key_vault_name`: Resource naming
- `deploy_powerbi`, `deploy_graph`, `deploy_graph_mail`, `deploy_fabric_capacity`: Feature toggles

## Outputs

After deployment, Terraform will output:

- App registration IDs
- Key Vault URI and tenant ID
- Names of created Key Vault secrets
- Fabric Capacity resource ID (if deployed)

## Notes

- **Admin Consent:** App permissions requested for Azure AD applications require admin consent. Grant consent manually in Azure Portal or via Azure CLI/Graph API after deployment.
- **Key Vault Access:** The specified admin user receives "Get" and "List" permissions for secrets.
- **Sensitive Data:** Secrets are stored securely in Azure Key Vault.

## Clean Up

To destroy all resources:
```sh
terraform destroy
```

## License

MIT (or specify your license)
