#!/bin/bash
# 1. Detect Host IP (Zsh friendly for macOS)
HOST_IP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)

if [ -z "$HOST_IP" ]; then
    echo "❌ Error: Network IP not found. Please check your WiFi."
    exit 1
fi

echo "------------------------------------------------"
echo "🚀 Atmos Prime - One-Click Setup"
echo "📡 Network IP: $HOST_IP"
echo "------------------------------------------------"

# 2. Hard Reset (Clean volumes and old network namespaces)
docker compose down --volumes --remove-orphans 2>/dev/null
rm -rf ./config

# 3. Generate Docker Compose File
cat > docker-compose.yml << EOL
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
    image: linuxserver/wireguard:latest
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
EOL

# 4. Start Deployment
docker compose up -d --build

echo "⏳ Waiting 25s for services to stabilize..."
sleep 25

# 5. Initial Data Seed (Prevents empty history brackets [])
curl -s -X POST http://localhost:8000/primes \
     -H 'Content-Type: application/json' \
     -d '{"start": 1, "end": 100}' > /dev/null

clear
echo "------------------------------------------------"
echo "✅ SETUP COMPLETE"
echo "------------------------------------------------"
echo "URL: http://10.13.13.1:8000/history"
echo "------------------------------------------------"

# 6. Display QR Code for WireGuard App
docker exec -it atmos-vpn /app/show-peer 1