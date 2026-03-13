resource "random_pet" "my-random-pet" {
  prefix = var.prefix
  separator = "."
}

output "my-random-pet-name" {
  value = random_pet.my-random-pet
  description = "The full name of the random generated pet"
}