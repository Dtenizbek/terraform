provider "aws" {}

resource "aws_instance" "my_Ubuntu" {
  ami           = "ami-0767046d1677be5a0"
  instance_type = "t3.micro"

  tags = {
    Name    = "My ubuntu server"
    Owner   = "Dtenizbek"
    Project = "Terraform lesssons"
  }
}
