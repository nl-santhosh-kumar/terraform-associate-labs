output "deployment_summary" {
  value = [for name, config in local.services : "Deployed ${name} on port ${config.port}"]
}