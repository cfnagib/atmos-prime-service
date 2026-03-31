resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  
  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = "production"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true 
}

# SECURITY DESIGN CHOICE: Restricted Ingress
# This Security Group acts as a primary firewall. We restrict port 8000 access 
# strictly to the VPN CIDR range. This prevents external actors from hitting 
# the API even if they discover the instance IP.
resource "aws_security_group" "api_sg" {
  name        = "${var.project_name}-api-sg"
  description = "Restricted access to VPN and Application port"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "API Access only via VPN Tunnel"
    from_port   = 8000
    to_port     = 8000
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