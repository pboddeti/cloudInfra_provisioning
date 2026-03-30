bucket_name   = "gcs-bucket-3-27-2026"
bucket_region = "us-central1"
force_destroy = false

# Upload .txt files from the data/ folder
# Add files to data/ folder, then reference them here:
objects = {
  "sample.txt" = file("${path.module}/data/sample.txt")
}
