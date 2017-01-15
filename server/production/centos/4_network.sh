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

firewall-cmd --permanent --zone=public --remove-port=22/ssh # if port 22 is enabled.
firewall-cmd --permanent --zone=public --add-port=${ssh_port}/ssh

# http, https, smtp
# v6

firewall-cmd --reload
