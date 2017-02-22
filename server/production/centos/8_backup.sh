#!/bin/bash

# Not execute
# It's the same as logrotate

# ================================
# variables
# ================================

app_name=$1

# ================================
# operation
# ================================

su

yum install -y rsync

cat << _EOF > /etc/rsync_exclude.lst
+ /home/***
+ /var/www/***
+ /var/log/nginx/***
+ /var/www/${app_name}/log/unicorn.log
_EOF

mkdir /var/backup

cat << _EOF > /etc/cron.monthly/rsync
/usr/bin/rsync -avz --delete --exclude-from=/etc/rsync_exclude.lst / /var/backup
_EOF

chmod +x /etc/cron.monthly/rsync
