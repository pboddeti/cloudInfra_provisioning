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
