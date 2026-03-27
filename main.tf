module "bucket" {
  source = "git::https://github.com/pboddeti/terraform_module_agent.git?ref=main"

  project_id    = var.project_id
  bucket_name   = var.bucket_name
  region        = var.region
  force_destroy = var.force_destroy
}
