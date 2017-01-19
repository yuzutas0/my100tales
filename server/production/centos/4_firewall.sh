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
# TCP Connection Flood
# HTTP GET Flood
# Ping of Death
# ICMP BLOCK (only accept: echo-request、echo-reply)
# Invalid Packet

firewall-cmd --reload
