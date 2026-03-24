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

resource "aws_s3_bucket_policy" "origin_bucket_policy" {
  bucket = aws_s3_bucket.static_site.id # Reference the S3 bucket created above
  policy = data.aws_iam_policy_document.iam_policy_document.json # Use the IAM policy document defined above as the bucket policy
}

locals {
  s3_origin_id = "myS3Origin"
  my_domain    = "mydomain.com"
}

data "aws_acm_certificate" "my_domain" {
  region   = "us-east-1"
  domain   = "*.${local.my_domain}"
  statuses = ["ISSUED"]
}

resource "aws_cloudfront_origin_access_control" "default_oac" {
  name = "default-oac"
  signing_behavior = "always"
  signing_protocol = "sigv4" 
  origin_access_control_origin_type = "s3" 
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.static_site.bucket_regional_domain_name # Use the regional domain name of the S3 bucket as the origin
    origin_id   = local.s3_origin_id # Use a local variable for the origin ID
    origin_access_control_id = aws_cloudfront_origin_access_control.default_oac.id # Reference the OAC created above to restrict access to the S3 bucket
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for my static site"
  default_root_object = "index.html"

  default_cache_behavior {
    target_origin_id       = local.s3_origin_id # Reference the origin ID defined above
    viewer_protocol_policy = "redirect-to-https" # Redirect HTTP requests to HTTPS

    allowed_methods = ["GET", "HEAD"] # Allow only GET and HEAD methods for caching
    cached_methods  = ["GET", "HEAD"] # Cache only GET and HEAD requests

    forwarded_values {
      query_string = false # Do not forward query strings to the origin

      cookies {
        forward = "none" # Do not forward cookies to the origin
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn            = data.aws_acm_certificate.my_domain.arn # Use the ACM certificate for the custom domain
    ssl_support_method             = "sni-only" # Use SNI for SSL support
    minimum_protocol_version       = "TLSv1.2_2021" # Set minimum TLS version for security
  }

  restrictions {
    geo_restriction {
      restriction_type = "none" # No geographic restrictions on content access
    }
  }

  tags = {
    Environment = "production"
  }
}

# Create a Route 53 record to point the custom domain to the CloudFront distribution
data "aws_route53_zone" "my_domain_zone" {
  name         = local.my_domain
  private_zone = false
}

resource "aws_route53_record" "cloudfront" {
  for_each = aws_cloudfront_distribution.s3_distribution.aliases # Create a Route 53 record for each alias defined in the CloudFront distribution
  zone_id = data.aws_route53_zone.my_domain_zone.zone_id # Reference the Route 53 hosted zone for the custom domain
  type    = "CNAME" # Use CNAME record to point to the CloudFront distribution
  ttl     = 300 # Set a low TTL for quick propagation
  name = each.value # Use the alias name defined in the CloudFront distribution as the record name

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}