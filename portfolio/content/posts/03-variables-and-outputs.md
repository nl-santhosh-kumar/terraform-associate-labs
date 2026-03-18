---
title: "03 | Making Code Reusable with Variables"
series: ["Terraform Associate 004"]
tags: ["Terraform", "Security", "Lab"]
weight: 30
showToc: true
summary: "Moving away from hardcoded values to dynamic, variable-driven configurations."
date: 2026-03-11
quiz:
  - question: "Which notation path do you use?"
    options: ["A) random_pet.id", "B) random_pet.my-pet.id"]
    answer: "B"
  - question: "What is the Terraform command to start a project?"
    options: ["A) terraform plan", "B) terraform init", "C) terraform apply"]
    answer: "B"
  - question: "Is Terraform state stored in a .tf file?"
    options: ["A) Yes", "B) No"]
    answer: "B"
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
View the full code here: [Challenge 03 Repo](https://github.com/nl-santhosh-kumar/terraform-associate-labs/tree/main/labs/03-variables)

## 1. Defining the Input
Instead of hardcoding the prefix "Mrs", let's create a variable. This allows other team members to use your code without editing the logic.

```hcl
variable "prefix" {
  type = string
  default = "Mrs"
  description = "Prefix of the pet"
}
```

## 2. Use the variable 
```hcl
# main.tf
resource "random_pet" "my-random-pet" {
  prefix = var.prefix
  separator = "."
}

# outputs.tf
output "my-random-pet-name" {
  value = random_pet.my-random-pet
  description = "The full name of the random generated pet"
}
```

## 3. The Output Anatomy
When you run terraform plan then you will see:
```hcl
my-random-pet-name = {
  "id" = "Mrs.awaited.bullfrog"
  "keepers" = tomap(null) /* of string */
  "length" = 2
  "prefix" = "Mrs"
  "separator" = "."
}
```
Why does it look like that?
You likely used an output that exported the entire resource object. While useful for debugging, it's "noisy." In the output above:

  - tomap(null): This is Terraform's way of saying, "This attribute is a Map type, but it's currently empty."

   - /* of string */: This is a hint that if you did provide values, they would need to be strings.

## 4. Refining the Output
When you run terraform apply then you will see:
```hcl
my-random-pet-name = {
  "id" = "Mrs.awaited.bullfrog"
  "keepers" = tomap(null) /* of string */
  "length" = 2
  "prefix" = "Mrs"
  "separator" = "."
}
```


---
## 🧠 Knowledge Check

Test your understanding of Terraform State and Outputs before moving to the next lesson.

{{< quiz >}}


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