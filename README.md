# 🚀 Terraform Learning Labs

A collection of hands-on labs designed to master Infrastructure as Code (IaC) using Terraform. This repository covers everything from basic resource provisioning to advanced modular architecture.

---

## 📋 Table of Contents
- [🚀 Terraform Learning Labs](#-terraform-learning-labs)
  - [📋 Table of Contents](#-table-of-contents)
  - [🛠 Prerequisites](#-prerequisites)
  - [📂 Lab Structure](#-lab-structure)
  - [📂 AWS Real World Scenarios](#-aws-real-world-scenarios)
  - [🚀 Getting Started](#-getting-started)
  - [⚠️ Security \& Cost Warning](#️-security--cost-warning)
  - [🧹 Cleanup](#-cleanup)
  - [⚖️ License](#️-license)

---

## 🛠 Prerequisites

Before starting these labs, ensure you have the following installed and configured:

1.  **Terraform CLI** (v1.0.0+): [Download here](https://www.terraform.io/downloads)
2.  **Cloud Provider Account**: (e.g., AWS, Azure, or GCP)
3.  **Provider CLI**: Properly configured with credentials (e.g., `aws configure`)
4.  **A Code Editor**: VS Code with the official HashiCorp Terraform extension is recommended.

---

## 📂 Lab Structure

Each lab is self-contained within the `/labs` directory:

| Lab ID | Name | Focus Area | Difficulty |
| :--- | :--- | :--- | :--- |
| **Lab 01** | [Local Sensitive File](./labs/01-local-sensitive-file) | Local Sensitive File | ⭐ (Beginner) |
| **Lab 02** | [Random Pet](./labs/02-random-pet) | Random Local Provider | ⭐ (Beginner) |
| **Lab 03** | [Variables](./labs/03-variables) | Reusable Variables | ⭐ (Beginner) |
| **Lab 04** | [Time Static](./labs/04-time-static) | Time Static | ⭐ (Beginner) |
| **Lab 05** | [Time Rotating](./labs/05-time-rotating) | Time Rotating | ⭐ (Beginner) |
| **Lab 06** | [Expressions](./labs/06-expressions) | Express | ⭐ (Beginner) |
| **Lab 07** | [Conditional Statement](./labs/07-conditional-statements) | Express | ⭐ (Beginner) |

## 📂 AWS Real World Scenarios
| Name | Focus Area | Difficulty |
| :--- | :--- | :--- |
| [Static Site With CloudFront](./aws/static-site-with-cloud-front) | The Professional Way to Host Static Content on AWS using Terraform | ⭐ (Beginner) |

---

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/nl-santhosh-kumar/terraform-associate-labs](https://github.com/nl-santhosh-kumar/terraform-associate-labs)
   cd terraform-labs/labs/01-local-sensitive-file
   ```

2. **Initialize the workspace:**
   ```bash
   terraform init
   ```

3. **Plan the infrastructure:**
   ```bash
   terraform plan
   ```

4. **Apply the changes:**
   ```bash
   terraform apply
   ```

---

## ⚠️ Security & Cost Warning

* **Secrets**: Never commit `.tfvars` files containing secrets or your `.tfstate` files to this repository. Use the provided `.gitignore`.
* **Costs**: Running these labs may incur charges from your cloud provider. Always check the `terraform plan` output before applying.
* **Auto-approve**: Avoid using `-auto-approve` until you are fully confident in the configuration.

---

[![Read the Document]](https://github.com/nl-santhosh-kumar/terraform-associate-labs/blob/main/Terraform_Cheat_Sheet.pdf)

## 🧹 Cleanup

To avoid ongoing charges, remember to destroy the resources once you have finished a lab:

```bash
terraform destroy
```

---

## ⚖️ License
Distributed under the MIT License. See `LICENSE` for more information.

---

**Maintained by:** Santhosh Kumar 
*Feel free to open an issue or a pull request if you find a bug or have an improvement!*