# Create a Route 53 record to point the custom domain to the CloudFront distribution
resource "aws_route53_record" "cloudfront" {
  # Iterates through the aliases you defined in your CloudFront resource
  for_each = aws_cloudfront_distribution.s3_distribution.aliases 
  
  zone_id = data.aws_route53_zone.my_domain_zone.zone_id
  name    = each.value
  
  # Use "A" for an Alias record pointing to a CloudFront distribution
  type    = "A" 

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}