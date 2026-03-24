resource "aws_s3_bucket" "static_site" {
  bucket = "my-static-site"
}

## Create a resource to restrict public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "static_site_public_access_block" {
  bucket = aws_s3_bucket.static_site.id # Reference the S3 bucket created above

  block_public_acls       = true # Block public ACLs (Access Control Lists) to prevent unauthorized access
  block_public_policy     = true # Block public bucket policies to prevent unauthorized access
  ignore_public_acls      = true # Ignore public ACLs to prevent unauthorized access
  restrict_public_buckets = true # Restrict public bucket policies to prevent unauthorized access
}