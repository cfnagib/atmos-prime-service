# Cloud Deployment Guide - Atmos Prime Service

## Overview
This guide outlines the professional deployment of the Prime Number Generator service on AWS using **Terraform** (Infrastructure as Code). The architecture is designed with a "Security-First" approach, ensuring the API is isolated from the public internet and only accessible via a secure VPN.

## Infrastructure Components (AWS)
- **VPC & Networking**: A dedicated Virtual Private Cloud with a Private Subnet.
- **Security Groups**: Strict firewall rules allowing inbound traffic only from the VPN IP range (Port 80).
- **AWS ECS (Fargate)**: Serverless container orchestration to run the application without managing EC2 instances.
- **CloudWatch**: Integrated logging for long-term maintenance and monitoring.

## Prerequisites
1. AWS CLI installed and configured with appropriate IAM permissions.
2. Terraform v1.0.0+ installed on the local machine.
3. Docker image pushed to a registry (e.g., Docker Hub).

## Deployment Steps
1. **Initialize Terraform**:
   ```bash
   cd terraform
   terraform init