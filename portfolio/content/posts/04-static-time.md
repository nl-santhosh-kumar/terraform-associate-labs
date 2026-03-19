---
title: "04 | Use the time_static resource to create persistent timestamps"
series: ["Terraform Associate 004"]
tags: ["Terraform", "Security", "Lab"]
weight: 40
showToc: true
summary: "Learn how to use the time_static resource to create persistent timestamps and avoid unnecessary resource drift."
quiz:
  - question: "Why does time_static stay the same while timestamp() changes?"
    options: ["A) time_static is more accurate.", "B) time_static saves its value in the .tfstate file; timestamp() does not.", "C) time_static only works on Linux."]
    answer: "B"
  - question: "You want to update the timestamp ONLY when the application version changes. What argument do you use?"
    options: ["A) lifecycle { ignore_changes = [...] }", "B) depends_on", "C) triggers = { version = var.app_version }"]
    answer: "B"
---

{{< include_lab "04-time-static/README.md" >}}
