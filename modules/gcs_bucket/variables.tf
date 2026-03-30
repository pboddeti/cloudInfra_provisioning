# Global variables (passed from root)
variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "Default GCP region"
  type        = string
  default     = "us-central1"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# GCS bucket specific variables
variable "bucket_name" {
  description = "GCS bucket name"
  type        = string
}

variable "bucket_region" {
  description = "Bucket region"
  type        = string
  default     = "us-central1"
}

variable "force_destroy" {
  description = "Delete objects when destroying bucket"
  type        = bool
  default     = false
}

variable "objects" {
  description = "Objects to upload to bucket"
  type        = map(string)
  default     = {}
}
