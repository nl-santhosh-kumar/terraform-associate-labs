# Challenge 01: Local Sensitive File

## 📋 Problem Statement
The objective is to provision a local file with specific security constraints using Terraform.

### Requirements:
1. **Provider:** Use the \`local\` provider.
2. **Resource:** Use \`local_sensitive_file\`.
3. **Path:** The file must be created at \`/sensitive_info.txt\`.
4. **Content:** The file should contain the password string provided in the lab.
5. **Permissions:** Set permissions to \`0600\` to ensure only the root user can read/write.

## 🚀 Solution
The solution code is located in the \`/solution\` directory. Run the following to deploy:
\`\`\`bash
terraform init
terraform apply
\`\`\`
EOF