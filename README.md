# ATMOS Case Study: Prime Number Microservice & VPN Infrastructure

This repository contains the complete solution for the Cloud & Software Engineer case study. The project implements a robust prime number generator, a containerized environment with a secure VPN gateway, and a comprehensive guide for cloud deployment.

## Architecture Overview
As per the technical requirements, the system is designed as a micro-service based application:
* **Application Service (FastAPI)**: Efficiently generates prime numbers in a user-provided range.
* **Database (PostgreSQL)**: Records each execution to ensure data persistence and history tracking.
* **VPN Gateway (WireGuard)**: Provides secure, encrypted access to the services, ensuring no direct public access to the API or Database.

## Quick Start (Automated Setup)
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

## Accessing the Service
Once the VPN tunnel is established, the HTTP API is accessible via:
* **Primary VPN URL**: http://10.13.13.1:8000/history
* **Developer Note (macOS)**: Due to a known networking regression in Docker Desktop for Mac (v4.23+), if the internal gateway IP is unreachable, use the Host LAN IP (e.g., http://<YOUR_MAC_IP>:8000/history) while the VPN is active to verify the secure tunnel handshake and service availability.

## API Endpoints
* **POST /primes**: Calculates primes in a given range.
    * *Payload:* `{"start": 1, "end": 100}`
* **GET /history**: Retrieves all execution records from the PostgreSQL database.

## Task 3: Cloud Deployment Guide
To transition this local setup to a production cloud environment (AWS/Azure):
1.  **Infrastructure**: Deploy on a Virtual Machine (e.g., AWS EC2) with Security Groups allowing only UDP 51820.
2.  **Security**: Ensure the Application and Database containers are NOT exposed to the public internet, accessible only through the VPN interface.
3.  **Scalability**: For long-term maintenance, it is recommended to use managed database services (like AWS RDS) and container orchestration (like Kubernetes).

## Technical Stack
* **Backend**: Python 3.13 (FastAPI)
* **Database**: PostgreSQL 16
* **Containerization**: Docker & Docker Compose
* **Security**: WireGuard VPN

---
**Contact**: Christian Nagib  
**Target Position**: Cloud & Software Engineer