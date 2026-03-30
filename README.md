# CloudInfra-Provision

Terraform project for provisioning Google Cloud resources using a modular pattern.

Current implemented service:
- GCS bucket + object uploads

## Project Structure

- providers.tf: Terraform version, backend, and Google provider
- variables.tf: Root input interface (global + service bridge variables)
- main.tf: Root orchestration (calls service modules)
- outputs.tf: Root outputs (global values)
- inputs/global.tfvars: Global values
- inputs/bucket.tfvars: Bucket-specific values
- data/: Files to upload to the bucket (for example sample.txt)
- modules/gcs_bucket/main.tf: GCS resources implementation
- modules/gcs_bucket/variables.tf: GCS module inputs
- modules/gcs_bucket/outputs.tf: GCS module outputs

## Input and Execution Flow

1. Terraform reads values from:
   - inputs/global.tfvars
   - inputs/bucket.tfvars
2. Root variables are declared in variables.tf.
3. Root main.tf passes values into module "gcs_bucket".
4. modules/gcs_bucket/main.tf creates:
   - google_storage_bucket
   - google_storage_bucket_object (for each object)

Note: tfvars files must contain literal values only (no function calls). File content resolution is done in code, not in tfvars.

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


