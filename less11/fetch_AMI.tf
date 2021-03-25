provider "aws" {
  region = "eu-west-1"

}
/*
resource "aws_instance" "myserver" {
  ami           = data.aws_ami.latest_ubuntu20.id
  instance_type = "t3.micro"
}
*/

data "aws_ami" "latest_ubuntu20" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]

  }
}

data "aws_ami" "latest_amazonlinux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]

  }
}
data "aws_ami" "latest_windowsserver2019" {
  owners      = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]

  }
}
output "latest_ubuntu20_ami_id" {
  value = data.aws_ami.latest_ubuntu20.id

}
output "latest_amazonlinux_ami_id" {
  value = data.aws_ami.latest_amazonlinux.id

}
output "latest_windowsserver2019_ami_id" {
  value = data.aws_ami.latest_windowsserver2019.id

}