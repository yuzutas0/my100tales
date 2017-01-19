#!/bin/bash

# ================================
# variables
# ================================

ssh_port=$1 # 49152 - 65535

# ================================
# check
# ================================

su

systemctl start firewalld
systemctl enable firewalld

firewall-cmd --list-all-zones
firewall-cmd --zone=public --list-service
firewall-cmd --get-services

# ================================
# port
# ================================

# OpenSSH
firewall-cmd --permanent --remove-service=ssh # if port 22 is enabled.
firewall-cmd --permanent --zone=public --add-port=${ssh_port}/tcp

# Postfix
firewall-cmd --permanent --zone=public --add-service=smtp

# Nginx
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https

# ================================
# disable IPv6
# ================================

echo "net.ipv6.conf.all.disable_ipv6 = 1" > /etc/sysctl.d/disableipv6.conf

sysctl -p

# ================================
# Guard Attacks
# ================================

# Spoofing Private Address
# Spoofing Broadcast Address
# Spoofing Multicast Address
# Fragment Packet Attack


# DENT Port Probe
# UDP Flood
# ICMP Flood (Ping Flood)

# Blank Packet
firewall-cmd  --permanent --direct --add-rule ipv4 filter INPUT 0 -p tcp --tcp-flags ALL NONE -j DROP

# SYN Flood
firewall-cmd --permanent --direct --add-chain ipv4 filter syn-flood
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 100 -i enp0 -p icmp --icmp-type echo-request -j syn-flood
firewall-cmd --permanent --direct --add-rule ipv4 filter syn-flood 150 -m limit --limit 1/s --limit-burst 4 -j RETURN
firewall-cmd --permanent --direct --add-rule ipv4 filter syn-flood 151 -j LOG --log-prefix "IPTABLES SYN-FLOOD:"
firewall-cmd --permanent --direct --add-rule ipv4 filter syn-flood 152 -j DROP

firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 200 -i enp0 -p tcp ! --syn -m state --state NEW -j LOG --log-prefix "IPTABLES SYN-FLOOD:"
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 201 -p tcp ! --syn -m state --state NEW -j DROP

# Stealth Scan
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p tcp --tcp-flags ALL ALL -j DROP

# TCP Connection Flood
# HTTP GET Flood

# Ping of Death
firewall-cmd --permanent --direct --add-chain ipv4 filter ping-death
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 300 -i enp0 -p icmp --icmp-type echo-request -j ping-death
firewall-cmd --permanent --direct --add-rule ipv4 filter ping-death 350 -m limit --limit 1/s --limit-burst 4 -j RETURN
firewall-cmd --permanent --direct --add-rule ipv4 filter ping-death 351 -j LOG --log-prefix "IPTABLES PING-DEATH:"
firewall-cmd --permanent --direct --add-rule ipv4 filter ping-death 352 -j DROP

# Port Scan
firewall-cmd --permanent --direct --add-chain ipv4 filter port-scan
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 400 -i enp0 -p tcp --tcp-flags SYN,ACK,FIN,RST RST -j port-scan
firewall-cmd --permanent --direct --add-rule ipv4 filter port-scan 450 -m limit --limit 1/s --limit-burst 4 -j RETURN
firewall-cmd --permanent --direct --add-rule ipv4 filter port-scan 451 -j LOG --log-prefix "IPTABLES PORT-SCAN:"
firewall-cmd --permanent --direct --add-rule ipv4 filter port-scan 452 -j DROP

# Spoofing
firewall-cmd --permanent --direct --add-chain ipv4 filter spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 500 -i enp0 -s 127.0.0.0/8 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 501 -i enp0 -d 127.0.0.0/8 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 502 -i enp0 -s 10.0.0.0/8 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 503 -i enp0 -s 172.16.0.0/12 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 504 -i enp0 -s 192.168.0.0/16 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 505 -i enp0 -s 192.0.2.0/24 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 506 -i enp0 -s 169.254.0.0/16 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 507 -i enp0 -s 224.0.0.0/4 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 508 -i enp0 -s 240.0.0.0/5 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 509 -i enp0 -s 0.0.0.0/8 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 510 -i enp0 -s 255.255.255.255 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 511 -i enp0 -s 333.333.333.210 -j spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter spoofing 550 -j LOG --log-prefix "IPTABLES SPOOFING:"
firewall-cmd --permanent --direct --add-rule ipv4 filter spoofing 551 -j DROP

# Win Port
firewall-cmd --permanent --direct --add-chain ipv4 filter win
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 600 -p tcp -m multiport --sport 135,137,138,139,445 -j win
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 601 -p udp -m multiport --sport 135,137,138,139,445 -j win
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 602 -p tcp -m multiport --dport 135,137,138,139,445 -j win
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 603 -p udp -m multiport --dport 135,137,138,139,445 -j win
firewall-cmd --permanent --direct --add-rule ipv4 filter win 650 -j LOG --log-prefix "USING WIN PORT:"
firewall-cmd --permanent --direct --add-rule ipv4 filter win 651 -j DROP

# ICMP BLOCK (only accept: echo-request、echo-reply)
# Invalid Packet

firewall-cmd --reload
