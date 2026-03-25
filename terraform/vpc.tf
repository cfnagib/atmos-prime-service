resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  
  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = "production"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  
  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}

resource "aws_security_group" "api_sg" {
  name        = "${var.project_name}-api-sg"
  description = "Managed by Terraform - Restricted access to VPN range"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpn_cidr_range]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}