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

- Pull Request to `main`: runs `fmt`, `validate`, `plan`, and comments plan on PR.
- Push/Merge to `main`: runs `apply` to deploy to GCP.

### Configure repository secrets

Add these in **Settings -> Secrets and variables -> Actions -> Secrets**:

- `GCP_WORKLOAD_IDENTITY_PROVIDER`
- `GCP_SERVICE_ACCOUNT`
- `TFVARS_CONTENT` (full content of your tfvars file)

`TFVARS_CONTENT` example value:

project_id    = "arctic-rite-403213"
bucket_name   = "gcs-bucket-3-27-2026"
region        = "us-central1"
force_destroy = false

The workflow writes this secret into `terraform.auto.tfvars` at runtime.

OIDC secrets are used for auth via `google-github-actions/auth`.

### Enforce plan before merge

In branch protection for `main`, add required status check:

- `plan`

This ensures PR merge is blocked if Terraform plan/validation fails.
