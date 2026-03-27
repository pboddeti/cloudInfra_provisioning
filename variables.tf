variable "project_id" {
  description = "GCP project ID where the bucket will be created"
  type        = string
}

variable "bucket_name" {
  description = "Globally unique bucket name"
  type        = string
}

variable "region" {
  description = "Bucket location/region"
  type        = string
  default     = "us-central1"
}

variable "force_destroy" {
  description = "Delete objects when destroying the bucket"
  type        = bool
  default     = false
}
