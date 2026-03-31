Atmos Space Cargo - Prime Service Case Study

🧪 Tech Stack

Backend: Python 3.13 / FastAPI

Database: PostgreSQL 16

Security: WireGuard VPN

IaC: Terraform / AWS ECS Fargate

🚀 Senior Design Decisions & Architectural Overview

This project is designed with a focus on Security, Performance, and Scalability, addressing high-level infrastructure requirements for space logistics operations.

1. Network Security (The "Zero-Exposure" Strategy)

To meet the strict security constraints, the FastAPI application is deployed with zero exposed ports to the public internet or the host machine.

The Choice: I implemented a "Sidecar Network" pattern. By using network_mode: "service:vpn" in Docker, the application is entirely shielded.

The Result: The service is invisible to the outside world. Communication is only possible through the encrypted WireGuard tunnel.

2. Algorithmic Excellence (Task 1)

Instead of a standard trial division loop, I utilized the Sieve of Eratosthenes.

Complexity: O(n log log n)

Why? For high-load scenarios handling large numerical ranges, this optimization is essential to reduce CPU overhead and ensure sub-second response times.

3. Cloud Infrastructure (Task 3 - AWS/Terraform)

The API is deployed within a dedicated VPC. Access is restricted via Security Groups that permit inbound traffic only from the VPN CIDR range.

ECS Fargate: Selected to eliminate server management overhead (No EC2 patching required).

Security Design: The infrastructure mirrors our local "Zero-Trust" networking model, ensuring that the cloud environment remains as secure as the local development stack.

🛠️ Setup & Execution

1. Local Development (Automated)

I have provided an automation script to handle dynamic IP updates and environment synchronization:

chmod +x auto_update_ip.sh
./auto_update_ip.sh


This script detects your Host IP, updates WireGuard configs, and starts the Docker stack.

2. Connecting to VPN

Once the stack is running, scan the generated QR Code in your terminal using the WireGuard app.

Crucial: Access the API at 10.13.13.1:8000 only after the tunnel is active.

🛠️ API Endpoints

POST /primes: Calculates primes in a range.

Payload: {"start": 1, "end": 100}

GET /history: Retrieves execution records from the PostgreSQL database.

⚠️ Technical Challenges & Troubleshooting

During development on macOS (Apple Silicon M4), a networking regression in Docker Desktop (v4.23+) was identified that affected internal routing to the WireGuard gateway.

Resolution: Implemented a strategic downgrade to Docker Desktop v4.18.0 to verify the integrity of the secure VPN tunnel and microservice communication.

Author: Christian Nagib