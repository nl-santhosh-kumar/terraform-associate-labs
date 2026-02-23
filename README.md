# terraform-associate-labs
🚀 A comprehensive collection of hands-on Terraform labs, configuration files, and infrastructure-as-code (IaC) challenges. Documenting my journey toward the HashiCorp Terraform Associate Certification.


## 📚 Technical Notes (from HashiCorp Docs)

### Local Provider Overview
The `local` provider is used to manage resources on the machine where Terraform is running. It does not require any cloud credentials.

### Resource: local_sensitive_file
- **Usage:** Used when the file contains secrets.
- **Behavior:** Prevents the `content` from being displayed in the terminal output.
- **Default Permissions:** Often more restrictive than `local_file`.

### Security Warning
Values marked as `sensitive` in Terraform are only masked in the **UI and Console**. They remain available in **plain text** within the `.tfstate` file.
