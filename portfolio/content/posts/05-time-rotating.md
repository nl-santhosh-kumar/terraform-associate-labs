---
title: "05 | Rotate a database password every 30 days with Time Rotating"
series: ["Terraform Associate 004"]
tags: ["Terraform", "IaC", "DevOps"]
summary: "Learn how to use the time_rotating to rotate a database password every 30 days"
showToc: true
weight: 50
---
## 🧠 The Core Concept: The "Trigger"
The primary purpose of time_rotating is to force other resources to recreate themselves. It’s a dependency anchor.

When the rotation period expires (e.g., 30 days), the time_rotating resource is marked as "changed" in the state file. Any resource that references its ID will also be forced to update or replace.


## A Real-World Implementation
Here is how you actually use it to rotate a database password every 30 days:

```hcl
# 1. Define the schedule
resource "time_rotating" "db_rotation_period" {
  rotation_days = 30
}

# 2. Generate a password that "depends" on the timer
resource "random_password" "db_pass" {
  length           = 16
  special          = true
  # This is the magic line:
  keepers = {
    rotation_id = time_rotating.db_rotation_period.id
  }
}

# 3. Use the local provider to save the new password
resource "local_sensitive_file" "db_config" {
  content  = "DB_PASSWORD=${random_password.db_pass.result}"
  filename = "${path.module}/.env"
}
```

Key Attributes to Know
rotation_days / rotation_hours / rotation_minutes: Defines how often the "alarm" goes off.

rfc3339: The output timestamp of the last rotation.

id: A unique value that changes every time a rotation occurs. This is what you usually pass into the keepers block of other resources.