# This file defines the IAM policy document that allows the CloudFront service principal to read objects from the S3 bucket.
data "aws_iam_policy_document" "iam_policy_document" {
  statement {
    sid = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"] # Allow CloudFront service principal to access the S3 bucket
    }

    actions = [
      "s3:GetObject", # Allow CloudFront to read objects from the S3 bucket
    ]

    resources = [
      "${aws_s3_bucket.static_site.arn}/*", # Allow access to all objects in the S3 bucket
    ]

    condition {
      test = "StringEquals"
      variable = "AWS:SourceArn"
      values = [aws_cloudfront_distribution.s_distribution.arn] # Restrict access to the S3 bucket to requests originating from the CloudFront distribution
    }
  }
}

locals {
  s3_origin_id = "myS3Origin"
  my_domain    = "mydomain.com"
}


#
data "aws_acm_certificate" "my_domain" {
  region   = "us-east-1"
  domain   = "*.${local.my_domain}"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "my_domain_zone" {
  name         = local.my_domain
  private_zone = false
}