#!/bin/bash

# TODO
su

yum install -y rsync

# DB, log, ...
cat << _EOF > /etc/rsync_exclude.lst
+ /home/***
+ /var/www/***
_EOF

cat << _EOF > /etc/cron.daily/rsync
/usr/bin/rsync -avz --delete --exclude-from=/etc/rsync_exclude.lst / /var/backup
_EOF

chmod +x /etc/cron.daily/rsync
