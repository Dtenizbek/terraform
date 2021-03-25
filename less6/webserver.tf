provider "aws" {
  region = "eu-central-1"
}


resource "aws_eip" "my_static_ip" {
  instance = aws_instance.my_webserver.id
  tags = {
    Name  = "Web Server IP"
    Owner = "Doelert Tenizbek"
  }
}


resource "aws_instance" "my_webserver" {
  ami                    = "ami-02f9ea74050d6f812"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data = templatefile("user_data.sh.tpl", {
    f_name = "Doelert",
    l_name = "Tenizbek",
    names  = ["Vasya", "Kolya", "Petya", "John", "Donald", "Masha", "Lena", "Katya"]
  })

  tags = {
    Name  = "Web Server Build by Terraform"
    Owner = "Doelert Tenizbek"
  }

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_security_group" "my_webserver" {
  name        = "my_webserver"
  description = "my first sec group"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
tags = {
  Name = "webserver security group"
  Owner = "Dtenizbek"
}
}

output "webserver_instance_id" {
    value = aws_instance.my_webserver.id

}
output "webserver_public_ip_address" {
    value = aws_eip.my_static_ip.public_ip
  
}