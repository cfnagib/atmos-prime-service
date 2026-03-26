resource "aws_vpc" "main_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  
  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = "production"
  }
}

# 1. Added Internet Gateway (Essential for ECS to pull images)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

# UPDATED: Renamed to public_subnet to align with map_public_ip_on_launch = true
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Required for ECS Fargate in public subnets to reach ECR/DockerHub
  
  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}

# 2. Added Route Table and Routes
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# 3. Security Group updated with correct ports
resource "aws_security_group" "api_sg" {
  name        = "${var.project_name}-api-sg"
  description = "Restricted access to VPN and Application port"
  vpc_id      = aws_vpc.main_vpc.id

  # Allow App port (8000) from VPN range
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [var.vpn_cidr_range]
  }

  # Allow Standard HTTP (80) for Load Balancer
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