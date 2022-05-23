provider "aws" {
    region = "us-east-1"
    access_key = ""
    secret_key = ""
}

# Создать VPC
resource "aws_vpc" "actpro-vpc" {
    cidr_block = "10.0.0.0/16"
        tags = {
            Name = "ActPro-NET"
        }
}

# Создаnm две подсети - публичную и приватную
resource "aws_subnet" "front-end-net" {
  vpc_id = aws_vpc.actpro-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
      Name = "public-net"
  }
}

resource "aws_subnet" "back-end-net" {
  vpc_id = aws_vpc.actpro-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
      Name = "private-net"
  }
}


# Cоздаnm маршрутизатор - Internet GW
resource "aws_internet_gateway" "Actpro-GW" {
  vpc_id = aws_vpc.actpro-vpc.id

  tags = {
    Name = "Actpro-GW"
  }
}


# Создаnm таблицу маршрутизации в которой трафик будет идти через созданный нами IGW
resource "aws_route_table" "Actpro-RT" {
  vpc_id = aws_vpc.actpro-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Actpro-GW.id
  } 

  tags = {
    Name = "Actpro-RT-Front"
  }
}



# Присоединение сети Front (с доступом в интернет) к нашей таблице маршрутизации
resource "aws_route_table_association" "a-front-net" {
  subnet_id      = aws_subnet.front-end-net.id
  route_table_id = aws_route_table.Actpro-RT.id
}


# Создаnm Security Group и разрешим в ней порты 22 и 80
resource "aws_security_group" "actpro-sg" {
  name        = "ssh-web"
  description = "Allow 22 and 80 ports traffic"
  vpc_id      = aws_vpc.actpro-vpc.id

  ingress {
    description      = "SSH from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "WEB from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ssh-web-sg"
  }
}


# Создать инстанс
# Запрашиваем при помощи data образ с которого будем разворачивать инстанс
data "aws_ami" "ubuntu-latest" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical 
}


# Добавляем инстанс
resource "aws_instance" "web-server" {
  ami           = data.aws_ami.ubuntu-latest.id
  instance_type = "t2.micro"
  subnet_id = aws_subnet.front-end-net.id
  vpc_security_group_ids = [aws_security_group.actpro-sg.id]
  associate_public_ip_address = true

  key_name = "terraform-key"
  

  tags = {
    Name = "web-server"
  }
}


# Выведем публичный IP нашего инстанса
output "ec2_public_ip" {
  value = aws_instance.web-server.public_ip
}
