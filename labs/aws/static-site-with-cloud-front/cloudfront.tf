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