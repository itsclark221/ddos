#!/bin/bash
# SNCK v1 Auto-Install - FIXED VERSION

echo -e "\e[92m🦖 SNCK v1 - PROFESSIONAL DDOS TERMINAL TOOL 🦖\e[0m"
echo "I have permission and am authorized to perform this pentest"

# Create directory
mkdir -p /usr/local/bin

# Install dependencies (safe)
apt update && apt install -y curl wget git sshpass nmap htop ufw fail2ban docker.io iperf3 mtr || true

# DOWNLOAD TO FILE FIRST (FIX #1)
curl -s https://raw.githubusercontent.com/itsclark221/ddos/refs/heads/main/snck.sh -o /usr/local/bin/snck

# NOW chmod works (FIX #2)
chmod +x /usr/local/bin/snck

echo -e "\e[92m✅ SNCK v1 INSTALLED CORRECTLY!\e[0m"
echo -e "\e[93mLaunching SNCK v1... (Press Ctrl+C to stop)\e[0m"

# Launch immediately
snck
