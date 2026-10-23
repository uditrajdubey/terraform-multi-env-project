
# Key Pair
resource "aws_key_pair" "my_key_pair" {
  key_name   = "${var.custom_env}-terra-automate-key"
  public_key = file("${path.module}/terra-automate-key.pub")
}

# Default VPC
resource "aws_default_vpc" "default" {}

# Security Group
resource "aws_security_group" "custom_security_group" {
  name        = "${var.custom_env}-terra-security-group"
  vpc_id      = aws_default_vpc.default.id # interpolation
  description = "Inbound and outbound rules for the instance security group"
}

# Inbound & Outbound rules
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.custom_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.custom_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic" {
  security_group_id = aws_security_group.custom_security_group.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # all protocols and ports
}

# EC2 Instances
resource "aws_instance" "my_instance" {
  count = var.ec2_count

  ami           = var.ec2_ami_id # use the same ami id - according to the region you provide in provider.tf
  instance_type = var.ec2_type

  key_name               = aws_key_pair.my_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.custom_security_group.id]

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
  }

  tags = {
    Name = "${var.custom_env}-terra-automate-server-${count.index}"
  }
}