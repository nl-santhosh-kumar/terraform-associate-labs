---
title: "01: Securing Data with Local Sensitive Files"
tags: ["Terraform", "Security", "Lab"]
series: ["Terraform Associate 004"]
description: "Mastering file permissions and console redaction in Terraform."
weight: 10
showButtons: true
buttons:
  - name: "📂 View Solution Files"
    url: "https://github.com/nl-santhosh-kumar/terraform-associate-labs/tree/main/challenges/01-local-provider"
    weight: 1
  - name: "🚀 Full Repository"
    url: "https://github.com/nl-santhosh-kumar/terraform-associate-labs"
    weight: 2
---

## 🛡️ The Concept: What is 'Sensitive'?

Standard resources like `local_file` can accidentally leak secrets (passwords, keys, tokens) into your terminal logs. 

**The Solution:** Use `local_sensitive_file` to gain two layers of protection:
* **Console Masking:** Automatically replaces secret values with `(sensitive value)` during `plan` and `apply`.
* **Disk Security:** Forces specific OS-level permissions on the created file.

---

## 🛠️ The Challenge: Lab Implementation

**Objective:** Create a file at `/sensitive_info.txt` that only the owner can read or write.

### 💻 The Solution Code
```hcl
resource "local_sensitive_file" "private_data" {
    content         = "my-password-123" # Tip: Use variables in production!
    filename        = "${path.module}/sensitive_info.txt"
    file_permission = "0600"
}
```

🔐 Why Use 0600 Permissions?
In Linux/Unix systems, permissions are calculated as follows:

6 (Owner): Read (4) + Write (2) = Full Access.

0 (Group): No Access.

0 (Others): No Access.

Result: Even if other users have access to your server/workspace, they cannot open or view your sensitive file.

###💡 Key Learnings

✅ Redaction: Terraform protects your screen/logs, but not your .tfstate file. State files still store this in plain text!

✅ Pathing: Used ${path.module} to ensure the file is created relative to the configuration folder.

✅ Automation: Learned how to enforce security compliance directly through Infrastructure as Code (IaC).

🚀 Resources
📂 View Challenge 01 Files

🏠 Back to Full Repository