output "tags" {
  value = {
    Project = "Phonix"
    Manager = "Dtenizbek"
    Country = "Canada"
  }
}

output "prod_server_size" {
  value = "t3.medium"
}

output "staging_server_size" {
  value = "t3.micro"
}