# Create a local file with sensitive content
resource "local_sensitive_file" "sensitive_data" {
  # The exact path the lab expects
  filename = "./sensitive_info.txt" #local path

  # The content requested by the problem statement
  content  = "my-ultra-secure-password"

  # Owner Read/Write only (0600)
  file_permission = "0600"
}

# NON SENSITIVE FILE - NOT PART OF THE PROBLEM STATEMENT, BUT INCLUDED TO SHOW THE DIFFERENCE IN PERMISSIONS
# 2. create a local file with sensitive content
resource "local_file" "non_sensitive_data" {
  filename = "./non_sensitive_info.txt" #local path
  content  = "my-non-sensitive-info" 
  file_permission = "0600"
}