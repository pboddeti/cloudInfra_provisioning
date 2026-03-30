resource "google_storage_bucket" "this" {
  name          = var.bucket_name
  project       = var.project_id
  location      = upper(var.bucket_region)
  force_destroy = var.force_destroy

  uniform_bucket_level_access = true

  labels = {
    environment = var.environment
  }
}

resource "google_storage_bucket_object" "objects" {
  for_each = var.objects

  bucket         = google_storage_bucket.this.name
  name           = each.key
  content        = each.value
  detect_md5hash = "different hash"
}

