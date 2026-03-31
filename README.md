# Atmos Prime Service
### Atmos Space Cargo — Cloud Software Engineer Case Study

---

## 🧪 Tech Stack

| Layer | Technology |
|---|---|
| **Backend** | Python 3.13 / FastAPI |
| **Database** | PostgreSQL 16 |
| **Security** | WireGuard VPN |
| **Containerization** | Docker / Docker Compose |
| **IaC** | Terraform / AWS ECS Fargate |
| **Monitoring** | AWS CloudWatch |

---

## 🚀 Architecture & Design Decisions

### 1. Network Security — The "Zero-Exposure" Strategy

The FastAPI application has **zero exposed ports** to the public internet or the host machine.

- **Pattern**: Sidecar Network via `network_mode: "service:vpn"` in Docker Compose
- **Result**: The service is completely invisible to the outside world
- **Access**: Only possible through the encrypted WireGuard VPN tunnel

### 2. Algorithmic Excellence — Sieve of Eratosthenes

Instead of a naive trial division loop, the prime generation uses the **Sieve of Eratosthenes**.

- **Complexity**: O(n log log n) vs O(n * sqrt(n)) for trial division
- **Why**: For high-load scenarios with large numerical ranges, this minimizes CPU overhead and ensures sub-second response times

### 3. Cloud Infrastructure — AWS / Terraform

The Terraform scripts in `/terraform` automate a hardened AWS environment:

- **ECS Fargate**: Serverless compute — no EC2 patching required
- **VPC**: Dedicated Virtual Private Cloud with strict network isolation
- **Security Groups**: Inbound traffic restricted exclusively to the VPN CIDR range (Port 8000)
- **CloudWatch**: Centralized logging with 7-day retention

---

## 🛠️ Local Setup & Execution

### Prerequisites
- Docker Desktop installed and running
- WireGuard app installed on your mobile device

### 1. Start the Stack (Automated)

An automation script handles dynamic IP detection, WireGuard config updates, and service startup:

```bash
chmod +x auto_update_ip.sh
./auto_update_ip.sh
```

This script will:
1. Detect your Host IP (macOS & Linux compatible)
2. Update the WireGuard endpoint configuration automatically
3. Start all Docker services

### 2. Connect to VPN

Scan the QR code displayed in your terminal using the **WireGuard app**.

> ⚠️ **Important**: The API is only accessible **after** the VPN tunnel is active.

---

## 📡 API Endpoints

### `POST /primes`
Calculates all prime numbers within a given range.

**Request Body:**
```json
{
  "start": 1,
  "end": 100
}
```

**Response:**
```json
{
  "status": "success",
  "execution_id": 1,
  "range": ,
  "count": 25,
  "primes": [2, 3, 5, 7, ...]
}
```

### `GET /history`
Retrieves all past execution records from the PostgreSQL database.

> Access via VPN only: `http://10.13.13.1:8000`

---

## ☁️ Cloud Deployment (AWS)

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Full deployment guide available in [`DEPLOYMENT_GUIDE.md`](./DEPLOYMENT_GUIDE.md)

---

## ⚠️ Troubleshooting

**Docker networking issue on macOS (Apple Silicon M4)**

A networking regression in Docker Desktop v4.23+ was identified affecting internal routing to the WireGuard gateway.

**Resolution**: Downgrade to Docker Desktop v4.18.0 to restore correct VPN tunnel behavior.

---

## 👤 Author

**Christian Nagib** — Cloud & DevOps Engineer  
[GitHub](https://github.com/cfnagib)