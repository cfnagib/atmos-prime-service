# ATMOS Case Study: Prime Number Microservice & VPN Infrastructure

This repository contains the complete solution for the Cloud & Software Engineer case study. The project implements a robust prime number generator, a containerized environment with a secure VPN gateway, and a comprehensive guide for cloud deployment.

## 🏗️ Architecture Overview
As per the technical requirements, the system is designed as a micro-service based application:
* **Application Service (FastAPI)**: Efficiently generates prime numbers in a user-provided range.
* **Database (PostgreSQL)**: Records each execution to ensure data persistence and history tracking.
* **VPN Gateway (WireGuard)**: Provides secure, encrypted access to the services.
* **Infrastructure as Code (Terraform)**: Complete AWS ECS Fargate deployment scripts are located in the `/terraform` directory.

## 🚀 Quick Start (Automated Setup)
To ensure the system is deployed with the correct network configurations and initial data seeding, use the provided automation script:

1.  **Run the deployment script**:
    ```bash
    chmod +x auto_update_ip.sh
    ./auto_update_ip.sh
    ```
    *This script dynamically detects the Host IP, updates the WireGuard configuration, starts the Docker stack, and seeds initial data to the database.*

2.  **Connect to VPN**:
    * Scan the generated QR Code in your terminal using the WireGuard app.
    * Use the configuration file generated in the console output.

## 📡 Accessing the Service
Once the VPN tunnel is established, the HTTP API is accessible via:
* **Primary VPN URL**: http://10.13.13.1:8000/history
* **Note on Connectivity**: The system is configured to allow secure inbound communication ONLY from the VPN network.

## 🛠️ API Endpoints
* **POST /primes**: Calculates primes in a given range.
    * *Payload:* `{"start": 1, "end": 100}`
* **GET /history**: Retrieves all execution records from the PostgreSQL database.

## ☁️ Task 3: Cloud Deployment Guide (AWS Implementation)
To transition this local setup to a production cloud environment, I have provided **Terraform (IaC)** scripts in the `/terraform` folder to automate the following architecture:

### 1. Infrastructure Setup (via Terraform)
* **Compute**: Managed via **AWS ECS (Fargate)** for serverless container orchestration.
* **Networking**: A dedicated **VPC** with public/private subnets, Internet Gateway, and Route Tables.
* **Database**: Integration with **Amazon RDS (PostgreSQL)** for production-grade persistence and scalability.

### 2. Access Control & Security
* **Security Groups**: Automated rules to allow UDP 51820 (VPN) and restrict API/DB access to internal traffic only.
* **Secrets Management**: Strategy for using **AWS Secrets Manager** to handle sensitive credentials.
* **Logging**: Integrated **CloudWatch Logs** for infrastructure monitoring.

### 3. Deployment Steps
1. Navigate to the `/terraform` directory.
2. Initialize and apply the configuration: `terraform init && terraform apply`.
3. Follow the detailed steps in `DEPLOYMENT_GUIDE.md` for full environment setup.

## ⚠️ Technical Challenges & Troubleshooting
During development on **macOS (Apple Silicon M4)**, a networking regression was identified in Docker Desktop (v4.23+). This bug prevented the host from correctly routing traffic to the internal WireGuard gateway IP (`10.13.13.1`).

**Resolution:**
A strategic **downgrade to Docker Desktop v4.18.0** was implemented to restore the internal routing layer, confirming the integrity of the microservice communication and the secure VPN tunnel.

## 🧪 Technical Stack
* **Backend**: Python 3.13 (FastAPI)
* **Database**: PostgreSQL 16
* **Security**: WireGuard VPN
* **IaC**: Terraform v1.0.0+

---
**Contact**: Christian Nagib  
**Target Position**: Cloud & Software Engineer