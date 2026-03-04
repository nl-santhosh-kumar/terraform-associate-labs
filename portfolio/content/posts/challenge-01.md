---
title: "01: Securing Data with Local Sensitive Files"
tags: ["Terraform", "Security", "Lab"]
description: "Understanding how Terraform manages sensitive local data and file permissions."
showButtons: true
buttons:
  - name: "📂 View Solution Files"
    url: "https://github.com/nl-santhosh-kumar/terraform-associate-labs/tree/main/challenges/01-local-provider"
    weight: 1
  - name: "🚀 Full Repository"
    url: "https://github.com/nl-santhosh-kumar/terraform-associate-labs"
    weight: 2
---

## The Concept: What is a 'Sensitive' Resource?

In Terraform, not all resources are created equal. When dealing with passwords, SSH keys, or API tokens, using a standard `local_file` resource is risky because Terraform might print the secret content directly into your terminal during a `plan` or `apply`.

**The Solution:** The `local_sensitive_file` resource.

### How it Works
1. **Console Redaction:** Terraform marks the `content` as `(sensitive value)`, hiding it from anyone watching your screen.
2. **File Permissions:** It allows us to set `file_permission`, ensuring that once the file is created on the disk, the OS protects it.

### The Objective
In this challenge, I had to ensure a local file was created with restricted permissions. 

### 📂 Access the Code
The full HCL implementation and the technical README are available in the repository:

👉 **[View Challenge 01 on GitHub](https://github.com/nl-santhosh-kumar/terraform-associate-labs/tree/main/01-local-sensitive-file)**

---
## 🛠️ The Challenge: Implementation

The requirement was to create a file at `/sensitive_info.txt` with permissions set to `0600` (Read/Write for the owner only).

### The Solution Code
You can find the full environment setup in the [Challenge 01 Folder](https://github.com/nl-santhosh-kumar/terraform-associate-labs/tree/main/01-local-sensitive-file).

```hcl
resource "local_sensitive_file" "private_data" {
    content         = "my-password-123" # In a real lab, use a variable!
    filename        = "${path.module}/sensitive_info.txt"
    file_permission = "0600"
}

---

Why 0600?
In Linux/Unix systems, permissions are represented by three numbers:
6 (Owner): Read (4) + Write (2) = 6.
0 (Group): No access.
0 (Others): No access.
This ensures that even if other users have access to your server, they cannot open your sensitive file.

### 💡 What I Learned
- **Sensitive Values:** How Terraform handles data it shouldn't show in the console.
- **Permissions:** Using `0600` in HCL to control the OS file system.
- **State:** Checking how the sensitive content is stored in `terraform.tfstate`.
