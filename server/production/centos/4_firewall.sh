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

# Keep Connection
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -m state --state ESTABLISHED,RELATED -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i lo -j ACCEPT

# Fragment Packet Attack
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -f -j DROP

# DENT Port Probe
# UDP Flood

# ICMP Flood (Ping Flood)
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p icmp --icmp-type 8 -m length --length :85 -m limit --limit 1/s --limit-burst 4 -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p tcp -m tcp --tcp-flags RST RST -m limit --limit 2/second --limit-burst 2 -j ACCEPT

# Blank Packet
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p tcp --tcp-flags ALL NONE -j DROP

# SYN Flood / Ping of Death
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p icmp --icmp-type echo-request -m limit --limit 1/s --limit-burst 4 -j ACCEPT
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p tcp ! --syn -m state --state NEW -j DROP

# Stealth Scan
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p tcp --tcp-flags ALL ALL -j DROP

# TCP Connection Flood
# HTTP GET Flood


# Port Scan
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -p tcp --tcp-flags SYN,ACK,FIN,RST -m state --state NEW -j REJECT --reject-with tcp-reset

# Spoofing
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 127.0.0.0/8 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 127.0.0.0/8 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 127.0.0.1/8 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 127.0.0.1/8 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 10.0.0.0/8 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 10.0.0.0/8 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 172.16.0.0/12 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 172.16.0.0/12 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 192.168.0.0/16 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 192.168.0.0/16 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 192.168.0.0/24 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 192.168.0.0/24 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 192.0.2.0/24 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 192.0.2.0/24 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 169.254.0.0/16 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 169.254.0.0/16 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 224.0.0.0/4 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 224.0.0.0/4 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 240.0.0.0/5 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 240.0.0.0/5 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 0.0.0.0/8 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 0.0.0.0/8 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 255.255.255.255 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 255.255.255.255 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -s 333.333.333.210 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -i enp0 -d 333.333.333.210 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -m pkttype --pkt-type broadcast -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -m pkttype --pkt-type multicast -j DROP

# Win Port
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -p tcp -m multiport -s 135,137,138,139,445 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -p udp -m multiport -s 135,137,138,139,445 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -p tcp -m multiport -d 135,137,138,139,445 -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -p udp -m multiport -d 135,137,138,139,445 -j DROP

# ICMP BLOCK (only accept: echo-request、echo-reply)
firewall-cmd --permanent --add-icmp-block=destination-unreachable
firewall-cmd --permanent --add-icmp-block=parameter-problem
firewall-cmd --permanent --add-icmp-block=redirect
firewall-cmd --permanent --add-icmp-block=router-advertisement
firewall-cmd --permanent --add-icmp-block=router-solicitation
firewall-cmd --permanent --add-icmp-block=source-quench
firewall-cmd --permanent --add-icmp-block=time-exceeded

# Invalid Packet
firewall-cmd --permanent --direct --add-rule ipv4 filter INPUT 0 -m state --state INVALID -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter FORWARD 0 -m state --state INVALID -j DROP
firewall-cmd --permanent --direct --add-rule ipv4 filter OUTPUT 0 -m state --state INVALID -j DROP

# Out of Rule
firewall-cmd --permanent --zone=public --set-target=DROP

firewall-cmd --reload
