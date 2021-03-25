provider "aws" {
    region = "eu-central-1"  
}

resource "aws_instance" "mywebserver" {
    ami = "ami-02f9ea74050d6f812"
    instance_type = "t3.micro"
    vpc_security_group_ids = [ aws_security_group.mywebserver.id ]
    user_data = <<EOF
#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h2>Webserver with IP: $myip</h2><br>Build by Terraform!" > /var/www/html/index.html
sudo service httpd start
chkonfig httpd on
EOF
tags = {
     Name = "webserver build by Terraform"
     Owner = "Dtenizbek"
}
}
resource "aws_security_group" "mywebserver" {
  name        = "mywebserve"
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