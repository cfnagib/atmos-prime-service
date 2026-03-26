#!/bin/bash

# 1. Detect Host IP (macOS WiFi en0 or Ethernet en1)
HOST_IP=$(ipconfig getifaddr en0 || ipconfig getifaddr en1)

if [ -z "$HOST_IP" ]; then
    echo "ERROR: Host IP not detected. Please check your network connection."
    exit 1
fi

echo "------------------------------------------------"
echo "Starting Atmos Prime Service"
echo "Detected Host IP: $HOST_IP"
echo "------------------------------------------------"

# 2. Export variables for Docker Compose (This injects the IP without changing the file)
export HOST_IP=$HOST_IP
export DB_USER=atmos
export DB_PASSWORD=atmospass
export DB_NAME=primesdb

# 3. Clean start
docker compose down --volumes --remove-orphans 2>/dev/null
# Clean old config only if necessary to ensure fresh VPN keys
rm -rf ./config/wireguard 

# 4. Launch Stack using the existing docker-compose.yml
docker compose up -d --build

echo "------------------------------------------------"
echo "Services are initializing (Wait 30s)..."
echo "------------------------------------------------"
sleep 30

# 5. Initialize Database with first record (Optional Seeding)
curl -s -X POST http://localhost:8000/primes \
     -H 'Content-Type: application/json' \
     -d '{"start": 1, "end": 50}' > /dev/null

echo "SUCCESS: Project is live."
echo "VPN Access: http://10.13.13.1:8000/history"
echo "Local Access: http://localhost:8000/history"
echo "------------------------------------------------"

# 6. Show VPN QR Code
docker exec -it atmos-vpn /app/show-peer 1