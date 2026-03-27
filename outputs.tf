output "bucket_name" {
  description = "Created bucket name"
  value       = module.bucket.bucket_name
}

output "bucket_id" {
  description = "Created bucket ID"
  value       = module.bucket.bucket_id
}

output "bucket_url" {
  description = "Created bucket URL"
  value       = module.bucket.bucket_url
}
