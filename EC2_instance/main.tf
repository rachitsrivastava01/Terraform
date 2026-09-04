terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
  required_version = ">=1.16.1"
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "my-terraform-key"
  public_key = file("C:/Users/Rachit/.ssh/id_rsa.pub")
}

resource "aws_security_group" "ssh_sg" {
  name        = "allow-ssh"
  description = "Allow SSH from my IP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["<your-ip>/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "My_first_ec2" {
  ami                    = "ami-01a00762f46d584a1"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.ssh_sg.id]

  tags = {
    Name = "Jenkins"
  }
}
