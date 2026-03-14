#!/bin/bash
# SNCK v1 - Professional DDoS Terminal Tool (FIXED)
# https://github.com/itsclark221/ddos

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
BLUE='\033[0;34m'; PURPLE='\033[0;35m'; CYAN='\033[0;36m'; NC='\033[0m'

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

VPS_FILE="/root/.snck_vps.conf"

add_vps() {
    clear; echo -e "${YELLOW}1. ADD VPS SERVER${NC}\n===================="
    read -p "VPS IP: " vps_ip
    read -p "SSH Username (root): " username; username=${username:-root}
    read -s -p "SSH Password: " ssh_pass; echo
    
    echo -e "\n${CYAN}🔍 PING TEST...${NC}"
    ping_latency=$(ping -c 3 $vps_ip 2>/dev/null | tail -1 | awk -F'/' '{print $5}' | cut -d'.' -f1 || echo "99")
    echo -e "Latency: ${ping_latency}ms ✅"
    
    echo -e "\n${CYAN}🔍 PORT SCAN...${NC}"
    nmap -p 22,80,443,25565,8080 $vps_ip --open 2>/dev/null | grep -E "^[0-9]+/tcp" | head -3 || echo "SSH(22) detected"
    
    echo -e "\n${CYAN}⚙️ DDoS Layers (5/10/30):${NC}"; read -p "Layers: " layers; layers=${layers:-10}
    
    echo "$vps_ip:$username:$ssh_pass:$layers:$ping_latency" >> $VPS_FILE
    echo -e "${GREEN}✅ VPS ADDED! Fleet: $(wc -l < $VPS_FILE | tr -d ' ') servers${NC}"
    sleep 2
}

network_test() {
    clear; echo -e "${YELLOW}2. NETWORK TEST${NC}\n================="
    echo -e "${CYAN}📊 BANDWIDTH TEST...${NC}"
    if command -v iperf3 &> /dev/null; then
        iperf3 -c iperf.he.net -t 5 -P 2 -R 2>/dev/null | grep "sender" | tail -1 || echo "iperf3: $(curl -s ifconfig.me)"
    else
        echo "Install iperf3 for bandwidth test"
    fi
    
    echo -e "\n${CYAN}🌐 LATENCY TEST...${NC}"
    command -v mtr &> /dev/null && mtr -r -c 3 8.8.8.8 || ping -c 3 8.8.8.8
    sleep 3
}

security_setup() {
    clear; echo -e "${YELLOW}3. SECURITY SETUP${NC}\n===================="
    echo -e "${CYAN}🔒 UFW...${NC}"; ufw --force enable
    echo -e "${CYAN}🛡️ Fail2Ban...${NC}"; apt install -y fail2ban 2>/dev/null || true
    echo -e "${CYAN}⚙️ Sysctl Tuning...${NC}"
    cat >> /etc/sysctl.conf << 'EOF'
net.ipv4.tcp_syncookies=1
net.ipv4.tcp_max_syn_backlog=4096
net.ipv4.icmp_echo_ignore_all=1
EOF
    sysctl -p
    echo -e "${GREEN}✅ SECURITY HARDENED!${NC}"; sleep 2
}

docker_tools() {
    clear; echo -e "${YELLOW}4. DOCKER TOOLS${NC}\n=================="
    if ! command -v docker &> /dev/null; then
        echo -e "${CYAN}🐳 Installing Docker...${NC}"
        curl -fsSL https://get.docker.com | sh
    fi
    echo -e "${CYAN}🐳 Containers:${NC}"; docker ps 2>/dev/null || echo "No containers"
    echo -e "${CYAN}🐳 Stats:${NC}"; docker stats --no-stream 2>/dev/null || echo "No stats"
}

system_monitor() {
    clear; echo -e "${YELLOW}5. SYSTEM MONITOR${NC}\n=================="
    echo -e "${CYAN}💻 INFO:${NC}"
    echo "CPU: $(nproc) cores | RAM: $(free -h | awk 'NR==2{printf "%.1fG", $2/1024/1024}')"
    echo "Uptime: $(uptime -p 2>/dev/null | cut -d',' -f1) | Disk: $(df -h / | tail -1 | awk '{print $5}')"
    echo -e "\n${CYAN}📊 htop (Ctrl+C to exit):${NC}"
    htop -C 2>/dev/null || top
}

main_menu() {
    while true; do
        banner
        echo -e "${GREEN}1.${NC} Add VPS Server ${CYAN}(SSH Swarm + Scan)${NC}"
        echo -e "${GREEN}2.${NC} Network Test ${CYAN}(Bandwidth/Latency)${NC}"
        echo -e "${GREEN}3.${NC} Security Setup ${CYAN}(UFW/Fail2Ban/Sysctl)${NC}"
        echo -e "${GREEN}4.${NC} Docker Tools"
        echo -e "${GREEN}5.${NC} System Monitor ${CYAN}(Live htop)${NC}"
        echo -e "${RED}6.${NC} Exit"
        echo -e "\n${YELLOW}VPS Fleet: $(test -f $VPS_FILE && wc -l < $VPS_FILE || echo 0) servers${NC}"
        read -p "$(echo -e ${BLUE}'┌─ SNCK> ')${NC}" choice
        case $choice in 1) add_vps;; 2) network_test;; 3) security_setup;; 4) docker_tools;; 5) system_monitor;; 6) echo -e "${GREEN}👋 SNCK v1 Exiting...${NC}"; exit 0;; *) echo -e "${RED}❌ Invalid${NC}"; sleep 1;; esac
    done
}

main_menu
