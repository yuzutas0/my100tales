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
# Stealth Scan
# DENT Port Probe
# UDP Flood
# ICMP Flood (Ping Flood)

# SYN Flood
firewall-cmd --permanent --direct --add-chain ipv4 filter syn-flood
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 100 -i enp0 -p icmp --icmp-type echo-request -j syn-flood
firewall-cmd --permanent --direct --add-rule ipv4 filter syn-flood 150 -m limit --limit 1/s --limit-burst 4 -j RETURN
firewall-cmd --permanent --direct --add-rule ipv4 filter syn-flood 151 -j LOG --log-prefix "IPTABLES SYN-FLOOD:"
firewall-cmd --permanent --direct --add-rule ipv4 filter syn-flood 152 -j DROP

firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 200 -i enp0 -p tcp ! --syn -m state --state NEW -j LOG --log-prefix "IPTABLES SYN-FLOOD:"
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 201 -p tcp ! --syn -m state --state NEW -j DROP

# TCP Connection Flood
# HTTP GET Flood

# Ping of Death
firewall-cmd --permanent --direct --add-chain ipv4 filter ping-death
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 300 -i enp0 -p icmp --icmp-type echo-request -j ping-death
firewall-cmd --permanent --direct --add-rule ipv4 filter ping-death 350 -m limit --limit 1/s --limit-burst 4 -j RETURN
firewall-cmd --permanent --direct --add-rule ipv4 filter ping-death 351 -j LOG --log-prefix "IPTABLES PING-DEATH:"
firewall-cmd --permanent --direct --add-rule ipv4 filter ping-death 352 -j DROP

# ICMP BLOCK (only accept: echo-request、echo-reply)
# Invalid Packet

firewall-cmd --reload
