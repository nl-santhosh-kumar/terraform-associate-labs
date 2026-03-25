# The Professional Way to Host Static Content on AWS using Terraform

In an idea world, deploying a static website content into a S3 bucket, clicking "Make Public" and share the link. In that world, there are no security audit, no latency issues for user across the globe and no such thing as an "unsecured connection" warning in the browser.

In real time environment, "Public S3 Buckets" are often one way ticket to security meeting you do not want to attend. For professional grade deployment, you need:
* **Zero Public Access:** Keeping our storage origin locked down and private.
* **Global Speed:** Serving content from the edge, closer to the user.
* **Enforced Encryption:** Redirecting every visitor to https:// automatically.

In this post, I’m moving away from basic Terraform syntax and diving into a Real-Time Scenario: architecting a secure, private S3 origin fronted by Amazon CloudFront using Origin Access Control (OAC).

# The Architecture
To solve these real-world requirements, we aren't just deploying one resource. We are building a "handshake" between:
* **The Vault (S3):** Where our files live, completely private.
* **The Gatekeeper (CloudFront OAC):** The specialized permission that lets only our CDN inside.
* **The Messenger (CloudFront Distribution):** The service that delivers our site via HTTPS.

# The Implementation 
1. Amazon Simple Storage Service (Amazon S3)
Amazon Simple Storage Service (Amazon S3) is an object storage service offering industry-leading scalability, data availability, security, and performance. Millions of customers of all sizes and industries store, manage, analyze, and protect any amount of data for virtually any use case, such as data lakes, cloud-native applications, and mobile apps. With cost-effective storage classes and easy-to-use management features, you can optimize costs, organize and analyze data, and configure fine-tuned access controls to meet specific business and compliance requirements.

# Lets create a S3 bucket in terraform
```hcl 

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "my-static-bucket" # Name of the bucket. If omitted, Terraform will assign a random, unique name

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
```
Remember: 
* Bucket name is unique
* Bucket name must be lowercase and less than or equal to 63 characters in length.
* **force_destroy** - (optional, default = false): Boolean that indicates all object (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error. 

Now that, we have a S3 bucket, lets understand about the blocking public access

# Locking the Front Door | Make the S3 Bucket Private
Making the S3 bucket private is good but to make it impossible to be public makes it awesome. Even if someone tries to change it to public, the resource will override and block it. 
* 📂 [Read More About S3 Public Access Block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block)
* 📂 [Read more about blocking public access to your amazon s3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/access-control-block-public-access.html)

```hcl 
## Create a resource to restrict public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "static_site_public_access_block" {
  bucket = aws_s3_bucket.static_site.id # Reference the S3 bucket created above

  block_public_acls       = true # Block public ACLs (Access Control Lists) to prevent unauthorized access
  block_public_policy     = true # Block public bucket policies to prevent unauthorized access
  ignore_public_acls      = true # Ignore public ACLs to prevent unauthorized access
  restrict_public_buckets = true # Restrict public bucket policies to prevent unauthorized access
}
```

# Modern Handshake (CloudFront OAC)
Amazon CloudFront is a global content delivery network that securely delivers applications, websites, videos, and APIs to viewers across the globe in milliseconds.  Leverage CloudFront’s origin access identity (OAI) to secures S3 origin access to CloudFront only.
When using OAC, a typical request and response workflow will be:

1. A client sends HTTP or HTTPS requests to CloudFront
2. CloudFront edge locations receive the requests. If the requested object is not already cached, CloudFront signs the requests using OAC signing protocol
3. S3 origins authenticate, authorize, or deny the requests.
4. When configuring OAC,  “Do not sign requests”, “Sign requests”, and sign requests. For this case, do not choose, Do not override authorization header.

# Create a Cloudfront Distribution
Below are the details required to create a cloud front distribution
1. Choose a plan & Distribution Type
2. Distribution Name, Type and Route 53 Integration
3. Defining the Origin S3 Bucket & Path 
4. Settings (Allow Private S3 bucket access to cloudfront)
5. Security Handshake Origin Settings
6. Cache & Behavior Settings
7. Web Application Firewall 

# 1. Choose a plan and Distribution Type in cloud front
Let's create a s3 distribution and configure it
* Origin Details
* Domain Name: Use the regional domain name of the S3 bucket as the origin 
* Origin Id: S3 Origin ID
* Origin Access Control ID: Id of the Origin Access Control to set the bucket only accessible via the access control id.

Since we need the OAC ID (Origin Access Control), lets create it first.

# Create OAC 
```hcl
resource "aws_cloudfront_origin_access_control" "default_oac" {
  name = "default-oac"
  signing_behavior = "always"
  signing_protocol = "sigv4" 
  origin_access_control_origin_type = "s3" 
}
```

Now, lets use this in the S3 Distribution 

```hcl
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
} 
```

# Define Cache Behavior 
As part of defining cache behavior, 
* Target Origin ID : should point to S3 Origin ID
* Viewer Protocol Policy: Redirect HTTP request to HTTPS request
* Allowed Methods: Configure which methods are allowed to cache
* Cache Methods: Configure what requests can be cached
  
Along with this, configure Forwarded Values, such as query string and cookies. Based on the application setup you can determine these values.

```hcl
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
```
This goes part of the Cloud Front Distribution.

Additionally you can define restriction on the distribution such as Geo Restriction,
```hcl
  restrictions {
    geo_restriction {
      restriction_type = "none" # No geographic restrictions on content access
    }
  }
```
A Viewer Certificate is the configuration block in CloudFront that determines how your distribution handles SSL/TLS encryption for your end users. When a user visits your website (e.g., https://www.yourdomain.com), the Viewer Certificate is what provides the digital handshake to ensure the connection is secure and that the user is actually talking to your server, not an imposter.
Why is it needed?
In the world of modern web hosting, HTTPS is non-negotiable. Browsers will flag your site as "Not Secure" without it. The viewer_certificate block tells AWS which SSL certificate to use to prove your site's identity.

| Option                        | Use Case                                                                              | Cost                   |
| :---                          |  :---                                                                                 | :---                   |
|CloudFront Default Certificate | Used for the default AWS domain (e.g., d1234.cloudfront.net)                          | Free                   |
|ACM Certificate                | Used for custom domains (e.g., www.example.com). Managed via AWS Certificate Manager. |Free (for public certs) |

```hcl
viewer_certificate {
    cloudfront_default_certificate = true
  }
```

# Configuring OAC when creating a new CloudFront distribution
![Create Distribution](image.png)
Once the distribution is successfully created, you must update the s3 bucket policy. Before that, lets create OAC with terraform.

* 📂 **[Read More About Cloudfront Distribution](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution)** 
* 📂 **[Cloudfront Distribution | Developer Guide](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Introduction.html)** 

Note: CloudFront distributions take about 15 minutes to reach a deployed state after creation or modification. During this time, deletes to resources will be blocked. If you need to delete a distribution that is enabled and you do not want to wait, you need to use the retain_on_delete flag.