#!/bin/bash

# 1. Detect the current Network IP
HOST_IP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)
echo "🎯 Detected IP: $HOST_IP"

# 2. Cleanup old containers and configurations
docker compose down --volumes --remove-orphans
rm -rf ./config

# 3. Create a fresh docker-compose.yml file
cat << EOL > docker-compose.yml
services:
  db:
    image: postgres:16
    container_name: atmos-db
    restart: always
    environment:
      POSTGRES_USER: atmos
      POSTGRES_PASSWORD: atmospass
      POSTGRES_DB: primesdb
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

# 4. Start the stack
docker compose up -d --build
echo "⏳ Waiting 30s for services to stabilize..."
sleep 30

# 5. Inject Initial Data to avoid empty history []
curl -s -X POST http://localhost:8000/primes -H 'Content-Type: application/json' -d '{"start": 1, "end": 100}'

clear
echo "------------------------------------------------"
echo "✅ SUCCESS! PROJECT IS LIVE"
echo "URL: http://10.13.13.1:8000/history"
echo "------------------------------------------------"

# 6. Display QR Code for iPhone
docker exec -it atmos-vpn /app/show-peer 1