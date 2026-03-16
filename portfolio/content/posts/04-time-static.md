---
title: "Mastering time_static in Terraform"
series: ["Terraform Associate 004"]
tags: ["Terraform", "IaC", "DevOps"]
summary: "Learn how to use the time_static resource to create persistent timestamps and avoid unnecessary resource drift."
showToc: true
quiz:
  - question: "Why does time_static stay the same while timestamp() changes?"
    options: ["A) time_static is more accurate.", "B) time_static saves its value in the .tfstate file; timestamp() does not.", "C) time_static only works on Linux."]
    answer: "B"
  - question: "You want to update the timestamp ONLY when the application version changes. What argument do you use?"
    options: ["A) lifecycle { ignore_changes = [...] }", "B) depends_on", "C) triggers = { version = var.app_version }"]
    answer: "B"
---
## 🧠 The Concept: Input vs. Output
While standard functions like timestamp() change every single time you run terraform plan, time_static captures a moment in time and locks it into your state file until you explicitly tell it to change.

Why people use it
The most common use case is for tagging or naming resources with a "Created At" date. Without time_static, if you tagged an AWS instance with timestamp(), Terraform would try to update that tag on every single run because the time is always different.

time_static stays put, keeping your plan clean.

## 🚀 Key Features
Persistence: Once created, the rfc3339, unix, and other attributes remain constant.

Triggers: You can force the time to "refresh" by using the triggers argument. If any value in the trigger map changes, the resource is recreated with a new current timestamp.

Attributes: It provides various formats out of the box:

rfc3339 (e.g., 2026-03-16T10:26:00Z)

unix (Epoch seconds)

Individual components like year, month, day.

## Quick Example
```hcl
resource "time_static" "ami_update" {
  # This timestamp only changes if the AMI ID changes
  triggers = {
    ami_id = data.aws_ami.example.id
  }
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.example.id
  instance_type = "t3.micro"

  tags = {
    # This tag will only update when the time_static resource is triggered
    LastAmiUpdate = time_static.ami_update.rfc3339
  }
}
```

## 📋 The Challenge
In this challenge, you will create a local text file that records its own birth certificate. The goal is to prove that Terraform can "remember" the past without drifting every time you run a command.

### Requirements:
1. Create a time static
2. Create a static file  
   1. Name of the file: `vault.txt`.
   2. Content: *This file was sealed on: <time stamp>* (eg: This file was sealed on: 2026-03-16T09:57:46Z)


## 🚀 Try it Yourself!

Don't want to install Terraform? No problem. Click the button below to launch a free, pre-configured environment in your browser:

{{< lab_button user="your-user" repo="terraform-labs" path="labs/04-time-static/main.tf" name="Time Static" >}}


### The Solution
View the full code here: [Challenge 04 Repo](https://github.com/nl-santhosh-kumar/terraform-associate-labs/tree/main/labs/04-time-static)


## 🧠 Knowledge Check

Test your understanding of Terraform Time Static before moving to the next lesson.

{{< quiz >}}

## 📚 004 Exam: Official Documentation Reference

To master the variables and outputs section of the **Terraform Associate (004)** exam, I utilized the following official resources:

* [**Time Provider**](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static#schema): Documentation on Time Provider