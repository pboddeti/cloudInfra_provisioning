module "gcs_bucket_remote" {
  source = "git::https://github.com/pboddeti/terraform_module_agent.git?ref=main"

  project_id    = var.project_id
  bucket_name   = var.bucket_name
  region        = var.bucket_region
  force_destroy = var.force_destroy
  objects       = var.objects
  # Objects are uploaded from ${path.module}/../data/ folder
  # Define them in inputs/bucket.tfvars using file() function
  # Example: objects = { "file1.txt" = file("${path.module}/../../data/file1.txt") }
}

