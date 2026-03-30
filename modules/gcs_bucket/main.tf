# Bucket is provisioned via git module source
module "gcs_bucket_remote" {
  source = "git::https://github.com/pboddeti/terraform_module_agent.git?ref=main"

  project_id    = var.project_id
  bucket_name   = var.bucket_name
  region        = var.bucket_region
  force_destroy = var.force_destroy
}

# Object upload is handled locally on top of the git module bucket
resource "google_storage_bucket_object" "objects" {
  for_each = var.objects

  bucket         = module.gcs_bucket_remote.bucket_name
  name           = each.key
  content        = each.value
  detect_md5hash = "different hash"
}


