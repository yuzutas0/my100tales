#!/bin/bash

# logwatch
#   server security
#   nginx + application

# ================================
# disksize
# ================================

df -h

# ================================
# login
# ================================

fail2ban-client status sshd

ipset --list

less /var/log/fail2ban.log
