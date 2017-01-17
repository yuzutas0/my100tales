#!/bin/bash

# ================================
# variables
# ================================

ssh_port=$1

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
firewall-cmd --permanent --zone=public --add-port=${ssh_port}/ssh

# Postfix
firewall-cmd --permanent --zone=public --add-service=smtp

# Nginx
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https

firewall-cmd --reload
