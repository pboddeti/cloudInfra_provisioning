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
