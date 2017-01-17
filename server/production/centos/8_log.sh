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

last

fail2ban-client status sshd

less /var/log/fail2ban.log
