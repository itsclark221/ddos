#!/bin/bash
# SNCK v1 - Professional DDoS Terminal Tool
# Ubuntu/Debian Compatible | Docker Ready | SSH Swarm Manager

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
banner() {
    clear
    echo -e "${PURPLE}"
    cat << 'EOF'
    ██████╗ ██╗   ██╗███████╗    ████████╗ █████╗ ██████╗ ████████╗
    ██╔══██╗██║   ██║██╔════╝    ╚══██╔══╝██╔══██╗██╔══██╗╚══██╔══╝
    ██████╔╝██║   ██║███████╗       ██║   ███████║██████╔╝   ██║   
    ██╔══██╗██║   ██║╚════██║       ██║   ██╔══██║██╔══██╗   ██║   
    ██║  ██║╚██████╔╝███████║       ██║   ██║  ██║██║  ██║   ██║   
    ╚═╝  ╚═╝ ╚═════╝ ╚══════╝       ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═╝   ╚═╝   
                                                                  
    ${NC}${CYAN}v1.0 - Professional DDoS Terminal | SSH Swarm Manager${NC}
    ${GREEN}I have permission and am authorized to perform this pentest${NC}
EOF
}

# VPS Manager Storage
VPS_FILE="/root/.snck_vps.conf"

# 1. Add VPS Server
add_vps() {
    clear
    echo -e "${YELLOW}1. ADD VPS SERVER${NC}"
    echo "===================="
    
    read -p "VPS IP: " vps_ip
    read -p "SSH Username (root): " username
    username=${username:-root}
    read -s -p "SSH Password/Key: " ssh_pass
    
    echo -e "\n${CYAN}🔍 Testing ping latency...${NC}"
    ping_latency=$(ping -c 3 $vps_ip | tail -1 | awk -F'/' '{print $5}' | cut -d'.' -f1)
    echo "Latency: ${ping_latency}ms ✅"
    
    echo -e "\n${CYAN}🔍 Scanning common ports...${NC}"
    nmap -p 22,80,443,25565,8080 $vps_ip --open -oG - | grep "Ports: " | head -3
    
    echo -e "\n${CYAN}⚙️  DDoS Layers (5/10/30):${NC}"
    read -p "Layers: " layers
    layers=${layers:-10}
    
    echo "$vps_ip:$username:$ssh_pass:$layers:$ping_latency" >> $VPS_FILE
    echo -e "${GREEN}✅ VPS Added! Total: $(wc -l < $VPS_FILE)${NC}"
    sleep 2
}

# 2. Network Test
network_test() {
    clear
    echo -e "${YELLOW}2. NETWORK TEST${NC}"
    echo "================="
    
    echo -e "${CYAN}📊 Live Bandwidth Test (Safe)${NC}"
    iperf3 -c iperf.he.net -t 10 -P 4 -R | grep "sender" | tail -1
    
    echo -e "\n${CYAN}🌐 Latency Test${NC}"
    mtr -r -c 5 8.8.8.8
    
    sleep 3
}

# 3. Security Setup
security_setup() {
    clear
    echo -e "${YELLOW}3. SECURITY SETUP${NC}"
    echo "===================="
    
    echo -e "${CYAN}🔒 Enabling UFW...${NC}"
    ufw --force enable
    
    echo -e "${CYAN}🛡️ Installing Fail2Ban...${NC}"
    apt install fail2ban -y
    
    echo -e "${CYAN}⚙️ DDoS Protection Tuning...${NC}"
    cat >> /etc/sysctl.conf << 'EOF'
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_max_syn_backlog=4096
net.ipv4.icmp_echo_ignore_all=1
EOF
    sysctl -p
    
    echo -e "${GREEN}✅ Security hardened!${NC}"
    sleep 2
}

# 4. Docker Tools
docker_tools() {
    clear
    echo -e "${YELLOW}4. DOCKER TOOLS${NC}"
    echo "=================="
    
    if ! command -v docker &> /dev/null; then
        echo -e "${CYAN}🐳 Installing Docker...${NC}"
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        rm get-docker.sh
    fi
    
    echo -e "${CYAN}🐳 Running Containers:${NC}"
    docker ps
    
    echo -e "\n${CYAN}🐳 Docker Stats:${NC}"
    docker stats --no-stream
}

# 5. System Monitor
system_monitor() {
    clear
    echo -e "${YELLOW}5. SYSTEM MONITOR${NC}"
    echo "=================="
    
    echo -e "${CYAN}💻 System Info:${NC}"
    echo "CPU: $(nproc) cores | RAM: $(free -h | grep Mem | awk '{print $2}')"
    echo "Uptime: $(uptime -p)"
    echo "Disk: $(df -h / | tail -1 | awk '{print $5}')"
    
    echo -e "\n${CYAN}📊 Live Monitor (Press Ctrl+C):${NC}"
    watch -n 1 "htop -C"
}

# Main Menu
main_menu() {
    while true; do
        banner
        
        echo -e "${GREEN}1.${NC} Add VPS Server ${CYAN}(SSH Swarm)${NC}"
        echo -e "${GREEN}2.${NC} Network Test ${CYAN}(Bandwidth/Latency)${NC}"
        echo -e "${GREEN}3.${NC} Security Setup ${CYAN}(UFW/Fail2Ban)${NC}"
        echo -e "${GREEN}4.${NC} Docker Tools"
        echo -e "${GREEN}5.${NC} System Monitor ${CYAN}(CPU/RAM/Disk)${NC}"
        echo -e "${RED}6.${NC} Exit"
        
        echo -e "\n${YELLOW}VPS Fleet: $(wc -l < $VPS_FILE | tr -d ' ') servers ready${NC}"
        
        read -p "$(echo -e ${BLUE}'┌─ SNCK> ')${NC}" choice
        
        case $choice in
            1) add_vps ;;
            2) network_test ;;
            3) security_setup ;;
            4) docker_tools ;;
            5) system_monitor ;;
            6) echo -e "${GREEN}👋 SNCK v1 Exiting...${NC}"; exit 0 ;;
            *) echo -e "${RED}Invalid option${NC}"; sleep 1 ;;
        esac
    done
}

# Auto-start
main_menu
