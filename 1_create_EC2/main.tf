# --------------------------------------------------------
# Create EC2 (and install apache on it) and Security Group
# (Build WebServer during Bootstrap)
#----------------------------------------------------------

provider "aws" {
  access_key = ""
  secret_key = ""
  region     = "us-east-1"
}


resource "aws_instance" "my_webserver" {
  ami                    = "ami-03a71cec707bfc3d7"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = file("scripts/user_data.sh")

  tags = {
    Name = "Web Server Build by Terraform"
  }
}


resource "aws_instance" "my_webserver_2" {
  ami                    = "ami-03a71cec707bfc3d7"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_webserver.id]
  user_data              = file("scripts/user_data.sh")

  tags = {
    Name = "Web Server 2 Build by Terraform"
  }
  # my_webserver_2 will be created after my_webserver
  depends_on = [aws_instance.my_webserver]
}


resource "aws_security_group" "my_webserver" {
  name        = "WebServer Security Group"
  description = "SecurityGroup"

  # Loop
  dynamic "ingress" {
    for_each = ["80", "443", "8080", "1541", "9092"]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # Without loop
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.10.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web Server SecurityGroup"
  }

  # Zero DownTime Deploy
  lifecycle {
    create_before_destroy = true
  }
}
