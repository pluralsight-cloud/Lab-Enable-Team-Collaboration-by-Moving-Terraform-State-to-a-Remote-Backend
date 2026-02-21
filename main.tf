provider "aws" {
  region = "us-east-1"
}

# Toggle variable used to force a state change for locking demo
variable "tag_toggle" {
  type    = string
  default = "A"
}

# Latest AL2023 AMI from AWS public SSM parameter
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

# Find the lab's public subnet created by CloudFormation
data "aws_subnet" "lab_public" {
  filter {
    name   = "tag:Lab"
    values = ["terraform-remote-state"]
  }

  filter {
    name   = "tag:Role"
    values = ["tf-public-subnet"]
  }
}

# Find the lab's SSH security group created by CloudFormation
data "aws_security_group" "lab_ssh" {
  filter {
    name   = "tag:Lab"
    values = ["terraform-remote-state"]
  }

  filter {
    name   = "tag:Role"
    values = ["tf-ssh-sg"]
  }
}

resource "aws_instance" "demo" {
  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = "t3.micro"
  subnet_id              = data.aws_subnet.lab_public.id
  vpc_security_group_ids = [data.aws_security_group.lab_ssh.id]

  tags = {
    Name   = "tf-demo-ec2"
    Toggle = var.tag_toggle
  }
}
