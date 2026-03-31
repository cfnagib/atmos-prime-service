🚀 Atmos Space Cargo - Prime Service Case Study

🧪 Tech Stack

[cite_start]Backend: Python 3.13 / FastAPI [cite: 285]

[cite_start]Database: PostgreSQL 16 [cite: 286]

[cite_start]Security: WireGuard VPN [cite: 287]

[cite_start]IaC: Terraform / AWS ECS Fargate [cite: 288]

🏗️ Senior Design Decisions & Architectural Overview

[cite_start]This project is designed with a focus on Security, Performance, and Scalability, addressing high-level infrastructure requirements for space logistics operations[cite: 290].

1. Network Security (The "Zero-Exposure" Strategy)

[cite_start]To meet strict security constraints, the FastAPI application is deployed with zero exposed ports to the public internet or the host machine[cite: 292].

The Choice: Implemented a "Sidecar Network" pattern. [cite_start]By using network_mode: "service:vpn" in Docker, the application is entirely shielded[cite: 293].

The Result: The service is invisible to the outside world. [cite_start]Communication is only possible through the encrypted WireGuard tunnel[cite: 294].

2. Algorithmic Excellence (Task 1)

[cite_start]Instead of a standard trial division loop, I utilized the Sieve of Eratosthenes[cite: 296].

[cite_start]Complexity: O(n log log n) [cite: 297]

[cite_start]Why? For high-load scenarios handling large numerical ranges, this optimization is essential to reduce CPU overhead and ensure sub-second response times[cite: 298].

3. Cloud Infrastructure (Task 3 - AWS/Terraform)

The API is deployed within a dedicated VPC. [cite_start]Access is restricted via Security Groups that permit inbound traffic only from the VPN CIDR range[cite: 300].

[cite_start]ECS Fargate: Selected to eliminate server management overhead (No EC2 patching required)[cite: 301].

[cite_start]Security Design: The infrastructure mirrors our local "Zero-Trust" networking model, ensuring the cloud environment remains as secure as the local development stack[cite: 302].

🛠️ Setup & Execution

1. Local Development (Automated)

[cite_start]I have provided an automation script to handle dynamic IP updates and environment synchronization[cite: 305]:

chmod +x auto_update_ip.sh
./auto_update_ip.sh


[cite_start]This script detects your Host IP, updates WireGuard configs, and starts the Docker stack[cite: 307].

2. Connecting to VPN

[cite_start]Once the stack is running, scan the generated QR Code in your terminal using the WireGuard app[cite: 309].

[cite_start]Crucial: Access the API at 10.13.13.1:8000 only after the tunnel is active[cite: 310].

📡 API Endpoints

Method

Endpoint

Description

POST

/primes

Calculates primes in a range.

GET

/history

Retrieves execution records from PostgreSQL.

Sample Payload for /primes:

{
  "start": 1,
  "end": 100
}


⚠️ Technical Challenges & Troubleshooting

[cite_start]During development on macOS (Apple Silicon M4), a networking regression in Docker Desktop (v4.23+) was identified that affected internal routing to the WireGuard gateway[cite: 316].

[cite_start]Resolution: Implemented a strategic downgrade to Docker Desktop v4.18.0 to verify the integrity of the secure VPN tunnel and microservice communication[cite: 317].

[cite_start]Author: Christian Nagib [cite: 318]


### الخطوات عشان تطبقه دلوقتي:
1.  افتح ملف `README.md` في الـ Editor بتاعك.
2.  امسح كل اللي فيه وحط الكود اللي فوق ده.
3.  في الـ Terminal، نفذ الأوامر دي عشان يظهر التعديل فوراً:
    ```bash
    git add README.md
    git commit -m "docs: polish README with professional formatting and tables"
    git push origin main
