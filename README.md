# CloudInfra-Provision

Basic Terraform caller project for creating a GCS bucket using the module at:

- git::https://github.com/pboddeti/terraform_module_agent.git?ref=main

## Files

- providers.tf: Terraform and Google provider config
- main.tf: module invocation
- variables.tf: input variables
- outputs.tf: output values
- terraform.tfvars.example: sample variable values

## Usage

1. Create a tfvars file:

   cp terraform.tfvars.example terraform.tfvars

2. Update terraform.tfvars values.

3. Authenticate to GCP (example):

   gcloud auth application-default login

4. Provision:

   terraform init
   terraform plan
   terraform apply

## CI/CD (GitHub Actions)

Pipeline file:

- .github/workflows/terraform-ci-cd.yml

Behavior:

- Pull Request to `main`: runs `fmt`, `validate`, `plan`, and comments plan + inputs on PR.
- Push/Merge to `main`: runs `apply` to deploy to GCP.

### Configure repository variables

Add these in GitHub repository **Settings -> Secrets and variables -> Actions -> Variables**:

- `GCP_PROJECT_ID`
- `TF_BUCKET_NAME`
- `TF_REGION` (example: `us-central1`)
- `TF_FORCE_DESTROY` (`true` or `false`)

### Configure repository secrets

Add these in **Settings -> Secrets and variables -> Actions -> Secrets**:

- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_SERVICE_ACCOUNT`

These are used for OIDC auth via `google-github-actions/auth`.

### Enforce plan before merge

In branch protection for `main`, add required status check:

- `plan`

This ensures PR merge is blocked if Terraform plan/validation fails.
