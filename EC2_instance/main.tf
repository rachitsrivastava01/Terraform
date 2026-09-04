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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDtNyi1EnTvwqGFUlZuDhJ7vrBsw9HK8S/tIxMIv98EOUAo5/dXYrxa/uMIHmBrUO5i37kYAB1URsJ9lw1VL6CVTVTzYENEBI58SkItbrFiN3A3OAwn/f4h4861f9XgN+9wkIvU9vTtzu3UFlW5y0J5im9uDFAvJwujYjj7vP1q2q5wOwYjuQ578bH1dBzjmumrnORWMWNrXCDbEdgodWnBanF85J0IFa05PZVfkyFeXXe/X9COUbxFfNbhvUjEbBR/i0qflwu+1addWfu3E8ySnacN1c4YIrhVqeNG1P6Li2rw8YhoDKUJYOsaOPSipF79/HRG6JC1N3b1CWZWJzUSLSfaxsBjo9ZRaBCpEwYS9Oh63uDvH+by0fp5uKZi8ulvFPLNk7ilwPmYjAMZSQx5apzA635s1y6DT/t0MVEnufs0sfdI6Ad1ybbVEr6c9aKMSvXSrwrkq/NBnCxHP3K6S0Mm5v7tfoKo4J1NIj4MUT/qWJls/p4N+9ABlXO3SxZcb9f6wN5wQ8ZIfFTIEPjBCeW3r5n9WCgS8/MJwciAzRbdjIqL5SOFkEmkwB36yCyRQpREtD46cGoRBXfWuKJIG1L4sLtAIL77z0WyfK//fJB9uL8BOQS529w14CiNjZ93YAVka4/oNd5xyHz4CHN2hRXiBb/3Kld1NhL0Qc2xxw== rachit@Game-Boy"
}

resource "aws_security_group" "ssh_sg" {
  name        = "allow-ssh"
  description = "Allow SSH from my IP"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["49.36.169.234/32"]
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
