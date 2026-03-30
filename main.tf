module "gcs_bucket" {
  source = "./modules/gcs_bucket"

  # Global variables
  project_id  = var.project_id
  region      = var.region
  environment = var.environment

  # GCS inputs
  bucket_name   = var.bucket_name
  bucket_region = var.bucket_region
  force_destroy = var.force_destroy
  objects       = var.objects
}
