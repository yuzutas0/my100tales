#!/bin/bash

# ================================
# variables
# ================================

ssh_port=$1

# ================================
# check
# ================================

su

firewall-cmd --list-all-zones
firewall-cmd --zone=public --list-service
firewall-cmd --get-services

# ================================
# port
# ================================

# OpenSSH
firewall-cmd --permanent --zone=public --remove-port=22/ssh # if port 22 is enabled.
firewall-cmd --permanent --zone=public --add-port=${ssh_port}/ssh

# Postfix
firewall-cmd --permanent --zone=public --add-service=smtp
firewall-cmd --permanent --zone=public --add-port=465/tcp # for SMTPs

# http, https
# v6

firewall-cmd --reload
