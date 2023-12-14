provider "aws" {
  region = "us-east-1" # Change to your desired region
}

resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.subnet_cidr
  availability_zone = "us-east-1a"
  tags = {
    Name = "my-subnet"
  }
}


resource "aws_security_group" "vm_sg" {
  name        = "vm-sg"
  description = "Security group for VMs"
  vpc_id      = aws_vpc.my_vpc.id


  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
  }
}

resource "tls_private_key" "key" {
  algorithm = "RSA"
}

resource "aws_key_pair" "aws_key" {
  key_name = "ansible-ssh-key"
  public_key = tls_private_key.key.public_key_openssh
}

resource "random_password" "vm_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_instance" "vm" {
  count         = var.vm_count
  ami           = var.vm_image
  instance_type = var.vm_flavor
  subnet_id     = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.vm_sg.id]
  key_name = aws_key_pair.aws_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = element(var.instance_tags, count.index)
  }

 
}

resource "null_resource" "vm" {
  triggers = {
    vm_instance_ids = "'${join(",", aws_instance.vm[*].id)}'"
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i '${join(",", aws_instance.vm[*].public_ip)}' ./ansible/configure.yml"
  }
}