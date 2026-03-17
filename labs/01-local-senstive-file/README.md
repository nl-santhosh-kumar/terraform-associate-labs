
## 🛡️ The Concept: What is 'Sensitive'?

Standard resources like `local_file` can accidentally leak secrets (passwords, keys, tokens) into your terminal logs. 

**The Solution:** Use `local_sensitive_file` to gain two layers of protection:
* **Console Masking:** Automatically replaces secret values with `(sensitive value)` during `plan` and `apply`.
* **Disk Security:** Forces specific OS-level permissions on the created file.


👥 1. Protecting from the "Viewer" (Logs/Screen)
The primary "person" this protects is anyone watching your terminal or CI/CD logs.

The Problem: If you use a regular local_file, Terraform prints the password in plain text during a terraform apply.

The Fix: local_sensitive_file masks that content. If a colleague is screen-sharing with you, they won't see your secrets.

🔐 2. Protecting from "Other Users" (Linux Permissions)
This protects the file from other users logged into the same server.

Default Behavior: Usually, files created by a script might be readable by anyone on the system.

The Fix: By setting file_permission = "0600", you tell the Operating System: "Only the person who ran this Terraform command can touch this file."

🚫 3. The "State" Catch (The Security Gap)
It is a common misconception that "Sensitive" means the data is encrypted. It is not.

The Risk: Anyone with access to your terraform.tfstate file can see the secret in plain text.

The Person: This is why you must protect your State Backend (S3, Terraform Cloud, etc.) from unauthorized people.

### ⚖️ Comparison: Standard vs. Sensitive Resources

| Feature | `local_file` | `local_sensitive_file` |
| :--- | :--- | :--- |
| **Terminal Output** | Prints full content (Unsafe) | Masks content as `(sensitive)` |
| **File Permissions** | Default (Typically `0644`) | Restricted (Typically `0600`) |
| **CI/CD Visibility** | Secrets appear in logs | Secrets are redacted in logs |
| **State File** | Stored in Plain Text | **Stored in Plain Text** ⚠️ |
| **Best Use Case** | Public Configs, Readmes | SSH Keys, API Tokens, Passwords |

---

> ⚠️ **Critical Security Note:** > While `local_sensitive_file` protects your **terminal screen** and **local disk**, it does **NOT** encrypt the data in your `terraform.tfstate` file. Anyone with access to your state file can still see your secrets in plain text.
> 


## 🎯 Challenge: Secure the Secret Key

Now it's your turn! Your goal is to provision a sensitive file using Terraform while following strict security requirements.

### 🚩 The Mission
Create a Terraform configuration that meets the following criteria:

1.  **Resource Type:** Use the `local_sensitive_file` resource.
2.  **File Name:** The file should be created in your current directory and named `customer_api_key.txt`.
3.  **Content:** The file must contain the string: `SECRET_API_TOKEN_999`.
4.  **Privacy:** Ensure the file permissions are set so **only the owner** can read or write to it (hint: use the octal code for "Owner: RW, Group: None, Others: None").
5.  **Verification:** Run `terraform apply` and verify that the actual API token is **not** visible in your terminal output.

---

### 🛠️ Step-by-Step Instructions

* **Step 1:** Create a new file named `challenge.tf`.
* **Step 2:** Define the `local_sensitive_file` resource block.
* **Step 3:** Run `terraform init` to install the local provider.
* **Step 4:** Run `terraform apply` and observe the "Sensitive Value" redaction.
* **Step 5:** Check the file permissions in your terminal:
    ```bash
    ls -l customer_api_key.txt
    ```

---

### ❓ Self-Check Questions
* Did the terminal show `SECRET_API_TOKEN_999` during the apply? (It shouldn't!)
* What happens if you try to use a standard `local_file` resource instead?
* Can you find the secret token inside the `terraform.tfstate` file? (Open it and search!)

---

### 💡 Hint
If you get stuck on the permissions, remember the "Owner Only" rule:
* **Read (4) + Write (2) = 6**
* **No Access = 0**
* Resulting Code: `"0600"`
* 


### 💡 Key Learnings

✅ Redaction: Terraform protects your screen/logs, but not your .tfstate file. State files still store this in plain text!

✅ Pathing: Used ${path.module} to ensure the file is created relative to the configuration folder.

✅ Automation: Learned how to enforce security compliance directly through Infrastructure as Code (IaC).

## 🚀 Resources & Links
* 📂 **[View Challenge 01 Files](https://github.com/nl-santhosh-kumar/terraform-associate-labs/tree/main/labs/01-local-senstive-file/README.md)** — Explore the HCL configuration and solution
