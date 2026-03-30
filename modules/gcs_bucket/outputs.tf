output "bucket_name" {
  description = "Created bucket name"
  value       = module.gcs_bucket_remote.bucket_name
}

output "bucket_id" {
  description = "Created bucket ID"
  value       = module.gcs_bucket_remote.bucket_id
}

output "bucket_url" {
  description = "Created bucket URL"
  value       = module.gcs_bucket_remote.bucket_url
}

output "created_objects" {
  description = "Uploaded bucket objects"
  value = {
    for key, obj in google_storage_bucket_object.objects : key => {
      name       = obj.name
      bucket     = obj.bucket
      generation = obj.generation
      crc32c     = obj.crc32c
    }
  }
}

