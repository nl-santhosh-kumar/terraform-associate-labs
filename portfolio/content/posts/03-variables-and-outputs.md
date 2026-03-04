---
title: "03: Making Code Reusable with Variables"
date: 2026-03-05
series: ["Terraform Associate 004"]
weight: 30
showToc: true
summary: "Moving away from hardcoded values to dynamic, variable-driven configurations."
---

## 🧠 The Concept: Input vs. Output
In the 004 exam, HashiCorp expects you to know how data flows through a Terraform configuration. 

- **Input Variables:** Like function arguments. They allow users to customize the deployment without touching the main code.
- **Output Values:** Like return values. They highlight important information (like an IP address) after an `apply`.



---

## 📋 The Challenge
The goal is to refactor our "Random Pet" lab. Instead of hardcoding the length of the pet name, we will use a variable.

### Requirements:
1. Define a variable for `prefix`.
2. Define a variable for `separator`.
3. Output the final generated name to the terminal.

---

## 🚀 The Solution
View the full code here: [Challenge 03 Repo](https://github.com/nl-santhosh-kumar/terraform-associate-labs/tree/main/03-variables)

```hcl
# variables.tf
variable "prefix" {
  type        = string
  default     = "Mrs"
  description = "The prefix for the pet name"
}

# main.tf
resource "random_pet" "my-pet" {
  prefix    = var.prefix
  separator = "."
}

# outputs.tf
output "pet_name" {
  value       = random_pet.my-pet.id
  description = "The full generated pet name"
}
```

## 📚 004 Exam: Official Documentation Reference

To master the variables and outputs section of the **Terraform Associate (004)** exam, I utilized the following official resources:

### 1. Variables & Types
* [**Input Variables Overview**](https://developer.hashicorp.com/terraform/language/values/variables): Covers how to define variables, use default values, and set descriptions.
* [**Type Constraints**](https://developer.hashicorp.com/terraform/language/expressions/types): Crucial for 004. Explains the difference between primitive types (`string`, `number`, `bool`) and complex types (`list`, `map`, `object`).



### 2. The Data Flow
* [**Output Values**](https://developer.hashicorp.com/terraform/language/values/outputs): Documentation on how to expose information about your infrastructure to the command line or other configurations.
* [**Variable Precedence**](https://developer.hashicorp.com/terraform/language/values/variables#variable-definition-precedence): A favorite 004 exam topic. This page explains which value "wins" when a variable is defined in multiple places (e.g., `.tfvars` vs environment variables).

### 3. CLI Interaction
* [**Command: output**](https://developer.hashicorp.com/terraform/cli/commands/output): How to extract specific values from your state file after a successful apply.