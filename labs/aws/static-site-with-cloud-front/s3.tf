#This terraform file contains the code to create an S3 bucket

resource "aws_s3_bucket" "static_site" {
  bucket = "static-site-with-cloud-front-bucket" # Name of the S3 bucket to be created
}


## Create a resource to restrict public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "static_site_public_access_block" {
  bucket = aws_s3_bucket.static_site.id # Reference the S3 bucket created above

  block_public_acls       = true # Block public ACLs (Access Control Lists) to prevent unauthorized access
  block_public_policy     = true # Block public bucket policies to prevent unauthorized access
  ignore_public_acls      = true # Ignore public ACLs to prevent unauthorized access
  restrict_public_buckets = true # Restrict public bucket policies to prevent unauthorized access
}

# Create an IAM policy document to allow CloudFront to access the S3 bucket
resource "aws_s3_bucket_policy" "origin_bucket_policy" {
  bucket = aws_s3_bucket.static_site.id # Reference the S3 bucket created above
  policy = data.aws_iam_policy_document.iam_policy_document.json # Use the IAM policy document defined above as the bucket policy
}
