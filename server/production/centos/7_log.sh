#!/bin/bash

# ================================
# logwatch
# ================================

app_name=$1
os_user=$2

yum -y install logwatch
# check: /usr/share/logwatch/default.conf/logwatch.conf

cat << \_EOF > /etc/logrotate.d/unicorn
/var/www/${app_name}/shared/log/production.log {
  weekly
  rotate 4
  missingok
  notifempty
  copytruncate
  create 0664 wheel ${os_user}
    minsize 1M
  lastaction
    pid=/tmp/unicorn.pid
    test -s $pid && kill -USR1 "$(cat $pid)"
  endscript
}
_EOF

# ================================
# cpu
# ================================

top

vmstat

sar

# ================================
# i/o
# ================================

iostat

# ================================
# memory
# ================================

ps

free -h

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
