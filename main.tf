terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.6.0"
    }
  }
  required_version = ">= 0.14.9"
}

#Vraag AMI op voor UBUNTU
data "aws_ami" "ubuntu" {
most_recent = true
provider = aws
owners = ["099720109477"] # Canonical

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-*-*-amd64-server-*"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}

#SSH-Key transfer
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

#Create VM
resource "aws_instance" "terraserver" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.aws_instance_type
  key_name = "${aws_key_pair.deployer.key_name}"
  vpc_security_group_ids = [aws_security_group.aws_sg_terraserver.id]
  user_data = data.template_file.user_data.rendered
  tags = {
    Name  = var.server_name
  }
}

#Define VPC
data "aws_vpc" "aws_vpc_default" {
  default = true
}

/*
data "aws_vpc" "aws_vpc_custom" {
  id = var.aws_vpc_id
}
*/

#Cloud-Init (Install Apache)
data "template_file" "user_data" {
  template = file("${abspath(path.module)}/cloud_init.yaml")
}

#Create Firewall Rules
locals {
  ingress = [{
      port = 443
      description = "Port 443 HTTPS"
      protocol = "tcp"
  },
  {
      port = 80
      description = "Port 80 HTTP"
      protocol = "tcp"
  },
  {
      port = 22
      description = "Port 22 SSH"
      protocol = "tcp"
  }
  ]
}

resource "aws_security_group" "aws_sg_terraserver" {
  name        = "allow_http-hhtps-ssh"
  description = "Allow HTTP/HTTPS/SSH inbound traffic"
  vpc_id      = data.aws_vpc.aws_vpc_default.id

  dynamic "ingress" {
      for_each = local.ingress
      content {
        description      = ingress.value.description
        from_port        = ingress.value.port
        to_port          = ingress.value.port
        protocol         = ingress.value.protocol
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
        prefix_list_ids = []
        security_groups = []
        self = false
      }
  }
  
  egress =[
  {
    description = "Outgoing - ALL"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    prefix_list_ids = []
    security_groups = []
    self = false 
  }
  ]

  tags = {
    Name = "allow_http-https-ssh"
  }
}

#Make Terraform wait for completed AWS Status
resource "null_resource" "status" {
  provisioner "local-exec" {
    command = "aws ec2 wait instance-status-ok --instance-ids ${aws_instance.terraserver.id}"
  }
  depends_on = [
    aws_instance.terraserver
  ]
}

