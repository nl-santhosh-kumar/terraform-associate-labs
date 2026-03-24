# Create a Route 53 record to point the custom domain to the CloudFront distribution
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