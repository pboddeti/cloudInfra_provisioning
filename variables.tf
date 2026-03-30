# Global variables shared across all services
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

# GCS input variables (loaded at root from inputs/*.tfvars)
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
  description = "Map of object name => relative file path from repo root (for example: data/sample.txt)"
  type        = map(string)
  default     = {}
}

