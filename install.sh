#!/bin/bash
# SNCK v1 Auto-Install - Professional DDoS Terminal

echo -e "\e[92m🦖 SNCK v1 - PROFESSIONAL DDOS TERMINAL TOOL 🦖\e[0m"
echo "I have permission and am authorized to perform this pentest"

# Auto-detect distro
if [[ -f /etc/debian_version ]]; then
    apt update && apt install -y curl wget git sshpass nmap htop ufw fail2ban docker.io
elif [[ -f /etc/redhat-release ]]; then
    yum install -y curl wget git sshpass nmap htop firewalld fail2ban docker
fi

# Download main tool
curl -s https://raw.githubusercontent.com/itsclark221/ddos/refs/heads/main/snck.sh
chmod +x /usr/local/bin/snck

echo -e "\e[92m✅ SNCK v1 INSTALLED!\e[0m"
echo -e "\e[93mRun: snck\e[0m"
snck
