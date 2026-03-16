resource "time_static" "timer" {
  
}

resource "local_file" "vault" {
  filename = "vault.txt"
  content= "This file was sealed on: ${time_static.timer.rfc3339}"
}