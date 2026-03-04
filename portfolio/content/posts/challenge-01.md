---
title: "Challenge 01: Local Sensitive File"
tags: ["Terraform Associate", "Local Provider", "Security"]
showToc: true
weight: 1
description: "Provisioning local files with 0600 permissions using Terraform."
---

## 📋 Problem Statement
The objective is to provision a local file with specific security constraints. 

> **Exam Tip:** The `local_sensitive_file` resource is used when you don't want the file content to be printed in the CLI output during a `terraform plan` or `apply`.

### Requirements:
1. **Provider:** `local`
2. **Resource:** `local_sensitive_file`
3. **Path:** `/sensitive_info.txt`
4. **Permissions:** `0600` (Owner Read/Write only)

## 🚀 The Solution
In this lab, I practiced defining resource permissions directly in HCL.

```hcl
resource "local_sensitive_file" "private_data" {
    content  = "MySuperSecretPassword"
    filename = "${path.module}/sensitive_info.txt"
    file_permission = "0600"
}