# Infrastructure Connective Tissue 🧬

In Terraform, **expressions** are the logic layer that turns static configuration into a dynamic, intelligent infrastructure-as-code machine. Think of them as the "connective tissue" between your hardcoded values and your final cloud resources.

---

## 🛠️ 1. Types & Literals
The building blocks of HCL (Hashicorp Configuration Language) are straightforward but strict.

* **🔡 Strings:** `"hello"` (Always use double quotes).
* **🔢 Numbers:** `15` or `3.14`.
* **🔘 Booleans:** `true` or `false`.
* **📜 Lists:** `["us-east-1a", "us-east-1b"]` (Ordered collection of the same type).
* **🗺️ Maps:** `{ "env" = "prod", "dept" = "labs" }` (Key-value pairs for lookups).
---

## 🔗 2. String Interpolation & Templates
This is how you inject variables directly into your text strings or scripts.

```hcl
resource "aws_instance" "app" {
  tags = {
    # Dynamically naming the server based on a variable
    Name = "server-${var.environment}" 
  }
}

Pro Tip: You can also use here docs (<<-EOT) for multi-line strings, which is great for cloud-init scripts.

## ⚖️ 3. Conditional Expressions (Ternary)
Terraform uses the classic ternary syntax: condition ? true_val : false_val. This is the bread and butter of environment-specific logic.

```hcl
# Logic: If environment is 'prod', use m5.large; otherwise, use t3.micro.
instance_type = var.env == "prod" ? "m5.large" : "t3.micro"
```

## 🔄 4. for Expressions
This is where Terraform gets its power. You can transform one collection (like a list or map) into another.

* **To create a list:** `[for s in var.list : upper(s)]` 
* **To create a map:** `{for k, v in var.map : k => upper(v)}` 



