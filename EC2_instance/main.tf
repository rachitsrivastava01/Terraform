terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
required_version = ">=1.16.1"
}
  provider "aws" {
    region = "ap-south-1"
  }

resource "aws_instance" "My_first_ec2" {
   ami = "ami-01a00762f46d584a1"
   instance_type = "t3.micro"
tags = {
   Name = "My first terraform instance"
  }
}
resource "aws_key_pair" "deployer" {
  key_name   = "my-terraform-key"
  public_key = file("C:/Users/Rachit/.ssh/id_rsa.pub")
}
