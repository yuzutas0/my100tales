#!/bin/bash

# ================================
# virus
# ================================

su

yum install clamav clamav-update

vim /etc/freshclam.conf
# -----------------------------------------
# from: Example
# to:   #Example
# -----------------------------------------
# from: DatabaseMirror database.clamav.net
# to:   DatabaseMirror db.jp.clamav.net
# -----------------------------------------

freshclam
# check whether database is updated.

vim /etc/sysconfig/freshclam
# -----------------------------------------
# from: FRESHCLAM_DELAY=disabled.warn
# to:   #FRESHCLAM_DELAY=disabled.warn
# -----------------------------------------

clamscan -r / -i --remove
# check whether virus file is not found.

echo "/usr/bin/clamscan -r / --quiet --log=/var/log/clamav.log -i --remove" > /etc/cron.daily/clamav
chmod +x /etc/cron.daily/clamav

# ================================
# rootkit
# ================================

yum -y install rkhunter
rkhunter --update
rkhunter --propupd
rkhunter --check --skip-keypress
