output "first_az" {
  # Accessing a list by index [0]
  value = local.az_list[0]
}

output "prod_instance_type" {
  # Accessing a map by key
  value = local.env_config["prod"].instance_type
}

output "deployment_summary" {
  value = [for name, config in local.services : "Deployed ${name} on port ${config.port}"]
}