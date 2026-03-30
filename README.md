# CloudInfra-Provision

Terraform project for provisioning Google Cloud infrastructure using reusable git-sourced modules.

The GCS bucket is provisioned via the remote Terraform module:
- `git::https://github.com/pboddeti/terraform_module_agent.git?ref=main`

Object uploads to the bucket are handled locally on top of the git module.

## How It Works

This project uses a two-layer module pattern:

```
inputs/*.tfvars
      ↓
root variables.tf + main.tf        (orchestration layer)
      ↓
modules/gcs_bucket/main.tf         (service layer)
      ├── module "gcs_bucket_remote"  → git::github.com/pboddeti/terraform_module_agent  (creates bucket)
      └── google_storage_bucket_object                                                     (uploads objects)
```

- **Bucket provisioning** → delegated to the git module source
- **Object upload** → handled locally since the git module does not include object support
- **Root layer** → orchestrates all services, reads inputs, passes values down

## Project Structure

```
CloudInfra-Provision/
├── providers.tf                    # Terraform version, backend, Google provider
├── variables.tf                    # Root input interface (global + service bridge variables)
├── main.tf                         # Root orchestration (calls service modules)
├── outputs.tf                      # Root outputs (global values)
├── inputs/
│   ├── global.tfvars               # Global values (project_id, region, environment)
│   └── bucket.tfvars               # Bucket-specific values + object paths
├── data/                           # Files to upload to the GCS bucket
└── modules/
    └── gcs_bucket/
        ├── main.tf                 # Calls git module for bucket + local object resources
        ├── variables.tf            # GCS module inputs
        └── outputs.tf              # GCS module outputs
```

## Input and Execution Flow

1. Terraform reads values from:
   - inputs/global.tfvars
   - inputs/bucket.tfvars
2. Root variables.tf declares the input interface.
3. Root main.tf passes values into `module "gcs_bucket"`.
4. modules/gcs_bucket/main.tf:
   - calls `git::https://github.com/pboddeti/terraform_module_agent.git?ref=main` to create the bucket
   - creates `google_storage_bucket_object` resources for each file in `objects` map

Note: tfvars files must contain literal values only (no function calls). File path-to-content resolution is done in root main.tf using `file()`.

## Local Usage

1. Authenticate to GCP:

   ```
   gcloud auth application-default login
   ```

2. Initialize (downloads git module):

   ```
   terraform init
   ```

3. Validate:

   ```
   terraform validate
   ```

4. Plan:

   ```
   terraform plan -no-color \
     -var-file=inputs/global.tfvars \
     -var-file=inputs/bucket.tfvars \
     -out=tfplan
   ```

5. Apply:

   ```
   terraform apply -no-color tfplan
   ```

## Uploading Files to GCS

1. Add files under `data/` (example: `data/sample.txt`).
2. Map object name to relative file path in `inputs/bucket.tfvars`:

   ```hcl
   objects = {
     "sample.txt" = "data/sample.txt"
   }
   ```

3. Run plan/apply — file content is read and uploaded automatically.

## CI/CD (GitHub Actions)

Workflow: `.github/workflows/terraform-ci-cd.yml`

### Triggers

Push to any branch when files change in:
- `**/*.tf`
- `inputs/**/*.tfvars`
- `data/**`
- `.github/workflows/terraform-ci-cd.yml`

### Jobs

**plan** (all branches):
- fmt check
- init (downloads git module)
- validate
- imports existing bucket into state (prevents 409 conflict)
- plan with inputs/global.tfvars + inputs/bucket.tfvars

**apply** (main branch only):
- init
- imports existing bucket into state
- apply with inputs/global.tfvars + inputs/bucket.tfvars

## GitHub OIDC Configuration

Set these in **Settings → Secrets and variables → Actions → Variables**:

| Variable | Description |
|---|---|
| GCP_WORKLOAD_IDENTITY_PROVIDER | Workload Identity Provider resource name |
| GCP_SERVICE_ACCOUNT | Service account email |

Authentication uses `google-github-actions/auth` with Workload Identity Federation (OIDC). No JSON key files needed.

## Adding Another Service Module

For a new service (example: vpc):

1. Create:
   - `modules/vpc/main.tf` — resource definitions (call git module or write locally)
   - `modules/vpc/variables.tf` — inputs
   - `modules/vpc/outputs.tf` — outputs
2. Add module call in root `main.tf`
3. Add root variable declarations in `variables.tf`
4. Add input values in `inputs/vpc.tfvars`
5. Add `-var-file=inputs/vpc.tfvars` to CI plan/apply commands


## Local Usage

1. Authenticate to GCP:

   gcloud auth application-default login

2. Initialize:

   terraform init

3. Validate:

   terraform validate

4. Plan:

   terraform plan -no-color \
     -var-file=inputs/global.tfvars \
     -var-file=inputs/bucket.tfvars \
     -out=tfplan

5. Apply:

   terraform apply -no-color tfplan

## Uploading Files to GCS

1. Add files under data/ (example: data/sample.txt).
2. Map object name to relative file path in inputs/bucket.tfvars:

   objects = {
     "sample.txt" = "data/sample.txt"
   }

3. Run plan/apply.

## CI/CD (GitHub Actions)

Workflow: .github/workflows/terraform-ci-cd.yml

### Triggers

- Push to any branch when files change in:
  - **/*.tf
  - inputs/**/*.tfvars
  - data/**
  - .github/workflows/terraform-ci-cd.yml

### Jobs

- plan:
  - fmt check
  - init
  - validate
  - imports existing bucket into state (if present)
  - plan with inputs/global.tfvars + inputs/bucket.tfvars

- apply (main branch only):
  - init
  - imports existing bucket into state (if present)
  - apply with inputs/global.tfvars + inputs/bucket.tfvars

## GitHub OIDC Configuration

Set these in **Settings -> Secrets and variables -> Actions -> Variables**:

- GCP_WORKLOAD_IDENTITY_PROVIDER
- GCP_SERVICE_ACCOUNT

Authentication is handled by google-github-actions/auth using Workload Identity Federation (OIDC).


