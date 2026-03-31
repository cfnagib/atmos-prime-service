#!/bin/bash

# 1. Detect Host IP Address (macOS/Linux compatible)
# This ensures the WireGuard endpoint always points to the current machine's IP.
if [[ "$OSTYPE" == "darwin"* ]]; then
    HOST_IP=$(ipconfig getifaddr en0)
else
    HOST_IP=$(hostname -I | awk '{print $1}')
fi

echo "Detected Host IP: $HOST_IP"
export HOST_IP=$HOST_IP

# 2. Update WireGuard Configuration
# DESIGN CHOICE: Automating the endpoint update to ensure seamless VPN connectivity
# without manual modification of the wg0.conf file.
sed -i '' "s/Endpoint = .*:51820/Endpoint = $HOST_IP:51820/" config/wg0.conf 2>/dev/null || \
sed -i "s/Endpoint = .*:51820/Endpoint = $HOST_IP:51820/" config/wg0.conf

# 3. Start Services (Docker Stack)
# Restarting services to apply new network environment variables and secure the stack.
docker-compose down
docker-compose up -d

echo "------------------------------------------------"
echo "Deployment Complete. Access API at 10.13.13.1:8000 via VPN."
echo "------------------------------------------------"

# 4. Display VPN QR Code
# Providing the QR code directly in the terminal for quick mobile client setup.
docker exec -it atmos-vpn /app/show-peer 1