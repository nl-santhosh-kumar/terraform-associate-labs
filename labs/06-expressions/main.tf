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

locals {
  apps = {
    "frontend" = {
      dept        = "marketing"
      open_ports  = [80, 443]
      is_public   = true
    }
    "database" = {
      dept        = "engineering"
      open_ports  = [5432]
      is_public   = false
    }
    "internal-api" = {
      dept        = "engineering"
      open_ports  = [8080, 9090]
      is_public   = false
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

#Resource Generation: Use a for_each to create a local_file for every app in the map.
# Naming Convention: The filename should be: firewall-<APP_NAME>-<DEPT>.cfg.
# The "Filter" Challenge: Only create files for apps where is_public is false. (We want to skip the frontend for this specific internal firewall task).
# Content Formatting: Inside the file, the open_ports list must be converted into a single string separated by pipes (e.g., 80|443).
# The Output: Create an output that returns a list of all the departments represented in the apps map (Bonus: try to make the department names uppercase).

resource "local_file" "firewall-configuration" {
    for_each = { for key, value in local.apps: key => value if !value.is_public} 
    filename = "firewall-${each.key}-${each.value.dept}.cfg"
    content = <<EOT
        open_ports = ${join("|", [for open_port in each.value.open_ports: tostring(open_port)])}
        department = ${each.value.dept}
    EOT
}

output departments {
  value = distinct([
    for app in local_file.firewall-configuration: app.filename])
}

output "department_names_in_uppercase" {
  value = distinct([for key, value in local.apps: upper(value.dept)])
}