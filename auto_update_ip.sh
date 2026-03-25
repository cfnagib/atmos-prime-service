#!/bin/bash

# 1. Detect Host IP (macOS WiFi interface)
HOST_IP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)

if [ -z "$HOST_IP" ]; then
    echo "Error: Host IP not detected. Please check your WiFi."
    exit 1
fi

echo "Current Host IP: $HOST_IP"

# 2. Build docker-compose.yml
cat << EOF > docker-compose.yml
services:
  db:
    image: postgres:16
    container_name: atmos-db
    restart: always
    environment:
      - POSTGRES_USER=atmos
      - POSTGRES_PASSWORD=atmospass
      - POSTGRES_DB=primesdb
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U atmos -d primesdb"]
      interval: 5s
      timeout: 5s
      retries: 3

  vpn:
    # UPDATED: Using a stable legacy tag to fix macOS Docker routing bugs
    image: lscr.io/linuxserver/wireguard:v1.0.20210914-ls22
    container_name: atmos-vpn
    cap_add:
      - NET_ADMIN
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
      - SERVERURL=$HOST_IP
      - SERVERPORT=51820
      - PEERS=1
      - PEERDNS=1.1.1.1
      - INTERNAL_SUBNET=10.13.13.0
      - ALLOWEDIPS=10.13.13.0/24
    ports:
      - "51820:51820/udp"
      - "8000:8000"
    volumes:
      - ./config:/config
    restart: always

  app:
    build: .
    container_name: atmos-service
    network_mode: "service:vpn"
    depends_on:
      db:
        condition: service_healthy
    environment:
      - DATABASE_URL=postgresql+psycopg://atmos:atmospass@atmos-db:5432/primesdb
    restart: always
EOF

# 3. Complete Reset (Hard Cleanup)
docker compose down --volumes --remove-orphans 2>/dev/null
rm -rf ./config

# 4. Start Deployment
docker compose up -d --build

echo "Initializing stack with Legacy WireGuard (40s)..."
# Increased sleep slightly to ensure the older image stabilizes
sleep 40

# 5. Data Seeding (Fixes empty brackets [] issue)
curl -s -X POST http://localhost:8000/primes \
     -H 'Content-Type: application/json' \
     -d '{"start": 1, "end": 100}' > /dev/null

clear
echo "------------------------------------------------"
echo "SYSTEM DEPLOYED WITH STABILITY PATCH"
echo "------------------------------------------------"
echo "Primary VPN URL: http://10.13.13.1:8000/history"
echo "Alternative URL: http://$HOST_IP:8000/history"
echo "------------------------------------------------"

# 6. Show QR Code
docker exec -it atmos-vpn /app/show-peer 1