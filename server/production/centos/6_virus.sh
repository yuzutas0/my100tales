#!/bin/bash

# ================================
# install
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

# ================================
# daily update
# ================================

freshclam
# check whether database is updated.

vim /etc/sysconfig/freshclam
# -----------------------------------------
# from: FRESHCLAM_DELAY=disabled.warn
# to:   #FRESHCLAM_DELAY=disabled.warn
# -----------------------------------------

# ================================
# daily execute
# ================================

mkdir /var/infected_virus

clamscan -r -i --move=/var/infected_virus
# be sure that there is no virus file

echo "/usr/bin/clamscan -r --quiet --log=/var/log/clamav.log --move=/var/infected_virus" > /etc/cron.daily/clamav
chmod +x /etc/cron.daily/clamav

# ================================
# rootkit
# ================================

yum -y install rkhunter
rkhunter --update
rkhunter --propupd
rkhunter --check --skip-keypress
