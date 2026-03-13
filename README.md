# 🚀 Terraform Learning Labs

A collection of hands-on labs designed to master Infrastructure as Code (IaC) using Terraform. This repository covers everything from basic resource provisioning to advanced modular architecture.

---

## 📋 Table of Contents
- [🚀 Terraform Learning Labs](#-terraform-learning-labs)
  - [📋 Table of Contents](#-table-of-contents)
  - [🛠 Prerequisites](#-prerequisites)
  - [📂 Lab Structure](#-lab-structure)
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
| **Lab 01** | [Basic Instance](./labs/01-basic-instance) | Providers, Resources, Variables | ⭐ (Beginner) |
| **Lab 02** | [VPC Networking](./labs/02-vpc-networking) | State, Outputs, Networking | ⭐⭐ (Easy) |
| **Lab 03** | [Modular Web App](./labs/03-modules) | Reusable Modules, Loops | ⭐⭐⭐ (Intermediate) |

---

## 🚀 Getting Started

1. **Clone the repository:**
   ```bash
   git clone [https://github.com/YOUR_USERNAME/terraform-labs.git](https://github.com/YOUR_USERNAME/terraform-labs.git)
   cd terraform-labs/labs/01-basic-instance
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