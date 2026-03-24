#locals 
variable "is_internal_only" {
  type = bool
  default = false
}

# database service configuration
resource "local_file" "database_server_config" {
    filename = "${path.module}/configs/database_server_config.txt"
    
    # Using 'content' to build a string dynamically
    content  = <<EOT
resource "aws_security_group" "database_sg" {
  name = "database-security-group"

  %{ for port in (var.is_internal_only ? [5432] : [5432, 3306]) ~}
  ingress {
    from_port   = ${port}
    to_port     = ${port}
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }
  %{ endfor ~}
}
EOT
}