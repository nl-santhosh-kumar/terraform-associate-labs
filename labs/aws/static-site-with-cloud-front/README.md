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

* Lets create a S3 bucket in terraform
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

