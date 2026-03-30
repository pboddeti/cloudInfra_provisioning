output "bucket_name" {
  description = "Created bucket name"
  value       = google_storage_bucket.this.name
}

output "bucket_id" {
  description = "Created bucket ID"
  value       = google_storage_bucket.this.id
}

output "bucket_url" {
  description = "Created bucket URL"
  value       = google_storage_bucket.this.url
}

output "created_objects" {
  description = "Uploaded bucket objects"
  value = {
    for key, obj in google_storage_bucket_object.objects : key => {
      name         = obj.name
      bucket       = obj.bucket
      content_type = obj.content_type
      crc32c       = obj.crc32c
      generation   = obj.generation
      md5hash      = obj.md5hash
      media_link   = obj.media_link
      self_link    = obj.self_link
    }
  }
}
