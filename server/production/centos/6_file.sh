#!/bin/bash

# ================================
# disable SELinux
# ================================

su

setenforce 0

getenforce
# check: Disabled

vim /etc/sysconfig/selinux
# check: SELINUX=disabled

# ================================
# virus
# ================================

yum -y install clamav clamav-update

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

clamscan -r -i --remove
# check whether virus file is not found.

echo "/usr/bin/clamscan -r --quiet --log=/var/log/clamav.log -i --remove --exclude-dir=^/dev --exclude-dir=^/proc --exclude-dir=^/sys" > /etc/cron.daily/clamav
chmod +x /etc/cron.daily/clamav

# ================================
# rootkit
# ================================

yum -y install rkhunter

rkhunter --update
rkhunter --propupd

rkhunter --check --skip-keypress --report-warnings-only

vim /etc/sysconfig/rkhunter
# -----------------------------------------
# from: ALLOW_SSH_ROOT_USER=unset
# to:   ALLOW_SSH_ROOT_USER=no
# -----------------------------------------
# from: ALLOW_SSH_PROT_V1=2
# to:   ALLOW_SSH_PROT_V1=0
# -----------------------------------------

# ================================
# falsification
# ================================

yum -y install aide

aide --init

mv -f /var/lib/aide/aide.db.new.gz /var/lib/aide/aide.db.gz

vim /etc/aide.conf
# -----------------------------------------
# # custom
# /var/www CONTENT_EX
# !/var/log
# !/proc
# -----------------------------------------

aide -C

less /var/log/aide/aide.log

aide --update

cat << \_EOF > /etc/cron.daily/aidechecker
#!/bin/bash

MAILTO=root
LOGFILE=/var/log/aide/aide.log
AIDEDIR=/var/lib/aide

/usr/sbin/aide -u > $LOGFILE
cp $AIDEDIR/aide.db.new.gz $AIDEDIR/aide.db.gz

x=$(grep "Looks okay" $LOGFILE | wc -l)
if [ $x -eq 1 ]
then
  echo "All Systems Look OK" | /bin/mail -s "AIDE OK" $MAILTO
else
  echo "$(egrep "added|changed|removed" $LOGFILE)" | /bin/mail -s "AIDE DETECTED CHANGES" $MAILTO
fi
exit
_EOF

chmod 755 /etc/cron.daily/aidechecker
