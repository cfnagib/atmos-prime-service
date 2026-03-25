variable "aws_region" {
  description = "Region for infrastructure deployment"
  default     = "eu-central-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the main VPC"
  default     = "10.0.0.0/16"
}

variable "vpn_cidr_range" {
  description = "IP range allowed to access the API via VPN"
  default     = "10.0.2.0/24"
}

variable "project_name" {
  description = "Name of the project for tagging"
  default     = "atmos-prime-service"
}