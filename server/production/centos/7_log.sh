#!/bin/bash

# ================================
# logwatch
# ================================

yum -y install logwatch
# check: /usr/share/logwatch/default.conf/logwatch.conf

# ================================
# cpu
# ================================

vmstat

# ================================
# memory
# ================================

free

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
