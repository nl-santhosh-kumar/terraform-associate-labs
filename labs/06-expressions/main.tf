locals {
  # 1. THE DATA: A Map of Objects
  # Each key is a service name, and the value is its configuration
  services = {
    "auth-api" = {
      port        = 8080
      environment = "prod"
      tags        = ["security", "identity"]
    }
    "billing-svc" = {
      port        = 9090
      environment = "dev"
      tags        = ["finance", "internal"]
    }
    "gateway" = {
      port        = 80
      environment = "prod"
      tags        = ["networking", "public"]
    }
  }
}

# 2. THE RESOURCE: Using for_each to iterate
resource "local_file" "service_config" {
  # We iterate over our map. 
  # each.key will be "auth-api", "billing-svc", etc.
  # each.value will be the object containing port, env, and tags.
  for_each = local.services

  filename = "${path.module}/configs/${each.key}-config.txt"
  
  # 3. THE EXPRESSION: String interpolation and list joining
  content  = <<EOT
Service Name: ${each.key}
Port:         ${each.value.port}
Environment:  ${upper(each.value.environment)}
Labels:       ${join(", ", each.value.tags)}
EOT
}

# 4. THE OUTPUT: Using a 'for' expression to summarize
output "deployment_summary" {
  value = [for name, config in local.services : "Deployed ${name} on port ${config.port}"]
}