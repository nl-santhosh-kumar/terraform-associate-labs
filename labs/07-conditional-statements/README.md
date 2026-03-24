# Conditional Statements In Terraform

Conditional statements in Terraform are the "if-then-else" of your infrastructure. Unlike many programming languages that use if blocks, Terraform primarily uses the ternary operator for simple logic and the count meta-argument for resource-level logic.

---
## 1. The Ternary Operator 
   
The most common way to use a conditional is the ternary syntax. It evaluates a boolean expression and returns one of two values.

Syntax: ```condition ? value_if_true : value_if_false ```
Example: 
Suppose you want to set the instance type based on the environment:
``` hcl
variable "environment" {
  type    = string
  default = "dev"
}

locals {
  instance_size = var.environment == "prod" ? "t3.large" : "t3.micro"
}
```

## 2. Conditional Resource Creation (The Count Trick)
Terraform doesn't have a native if resource {} block. Instead, we use the count meta-argument. If count is set to 1, the resource is created; if it is 0, it is skipped.

Example:
Only create a backup bucket if the enable_backups variable is true:
```hcl
variable "enable_backups" {
  type    = bool
  default = true
}

resource "aws_s3_bucket" "backup" {
  # If true, count is 1 (create). If false, count is 0 (skip).
  count = var.enable_backups ? 1 : 0

  bucket = "my-app-backup-storage"
}
```

## 3. Dynamic Block (Conditional Logic)
Sometimes you don't want to skip an entire resource, just a specific configuration block inside it (like an extra security rule or a tag).

You can combine for_each with a conditional list to achieve this:
```hcl
resource "aws_security_group" "example" {
  name = "example-sg"

  # Only create this ingress block if 'is_public' is true
  dynamic "ingress" {
    for_each = var.is_public ? [1] : []
    content {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}
```
**Note**
In Terraform, both sides of a ternary operator must be the same type. You cannot return a string if true and a number if false. If you find yourself hitting type errors, you might need to use the tostring() or tonumber() functions to keep things consistent.

---

## Try it for Yourself!
To make this practical without requiring a cloud account, we will use a Local File use case.
Imagine you are building a module for a Database Server. Your goal is to make the security group smart enough to handle two different scenarios based on a single variable.

**The Scenario**
You have a variable called is_internal_only.

* If **is_internal_only** is **true**: The database should only open Port **5432** (PostgreSQL) for internal traffic.
* If **is_internal_only** is **false**: The database is considered "Legacy" and needs to open Port **5432** (PostgreSQL) AND Port **3306** (MySQL) for external migrations.
  
Your Goal:
* Write a dynamic "ingress" block that uses a ternary operator in the for_each to switch between these two lists of ports.**