#!/bin/bash

# ================================
# variables
# ================================

admin_mail=$1

# ================================
# logwatch
# ================================

yum -y install logwatch
# check /usr/share/logwatch/default.conf/logwatch.conf

vi /etc/aliases
# root: ${admin_mail}

newaliases

date | mail root
# check whether ${admin_mail} receives a mail from this server.

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
