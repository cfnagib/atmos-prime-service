# ATMOS Case Study: Prime Number Microservice & VPN Infrastructure

This repository contains the complete solution for the Cloud & Software Engineer case study. The project implements a robust prime number generator, a containerized environment with a secure VPN gateway, and a comprehensive guide for cloud deployment.

## 🏗️ Architecture Overview
As per the technical requirements, the system is designed as a micro-service based application:
* **Application Service (FastAPI)**: Efficiently generates prime numbers in a user-provided range.
* **Database (PostgreSQL)**: Records each execution to ensure data persistence and history tracking.
* **VPN Gateway (WireGuard)**: Provides secure, encrypted access to the services, ensuring no direct public access to the API or Database.

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
    * Alternatively, use the configuration file generated in `./config/peer1.conf`.

## 📡 Accessing the Service
Once the VPN tunnel is established, the HTTP API is accessible via:
* **Primary VPN URL**: http://10.13.13.1:8000/history
* **Note on Connectivity**: The system is configured to allow secure inbound communication ONLY from the VPN network.

## 🛠️ API Endpoints
* **POST /primes**: Calculates primes in a given range.
    * *Payload:* `{"start": 1, "end": 100}`
* **GET /history**: Retrieves all execution records from the PostgreSQL database.

## ☁️ Task 3: Cloud Deployment Guide (AWS Implementation)
To transition this local setup to a production cloud environment, the following architecture is proposed:

### 1. Infrastructure Setup
* **Compute**: Deploy the application on an **AWS EC2** instance (Ubuntu 22.04) or **Amazon ECS** for managed container orchestration.
* **Database**: Migrate from a local container to **Amazon RDS (PostgreSQL)** for better scalability, automated backups, and high availability.
* **Networking**: Deploy within a **VPC** with private subnets for the App and Database.

### 2. Access Control & Security
* **Security Groups**: 
    * Allow **UDP 51820** for WireGuard VPN access.
    * Strictly block all public access to ports **8000** (API) and **5432** (DB).
* **IAM Permissions**: 
    * Create a dedicated IAM Role for the EC2 instance with `AmazonRDSFullAccess` (if using RDS) and `CloudWatchLogsFullAccess` for monitoring.
    * Use **AWS Secrets Manager** to handle database credentials securely.

### 3. Deployment Steps
1. Provision VPC and Subnets using **Terraform** or AWS CLI.
2. Launch EC2 instance and install Docker/WireGuard.
3. Deploy the application using the provided `docker-compose.yml`.
4. Distribute WireGuard peer configurations only to authorized users.

## ⚠️ Technical Challenges & Troubleshooting
During development on **macOS (Apple Silicon M4)**, a networking regression was identified in Docker Desktop (v4.23+). This bug prevented the host from correctly routing traffic to the internal WireGuard gateway IP (`10.13.13.1`).

**Resolution:**
To maintain a stable environment and ensure full compliance with the VPN connectivity requirements, a strategic **downgrade to Docker Desktop v4.18.0** was implemented. This restored the internal routing layer, confirming the integrity of the microservice communication and the secure VPN tunnel.

## 🧪 Technical Stack
* **Backend**: Python 3.13 (FastAPI)
* **Database**: PostgreSQL 16
* **Containerization**: Docker & Docker Compose
* **Security**: WireGuard VPN

---
**Contact**: Christian Nagib  
**Target Position**: Cloud & Software Engineer