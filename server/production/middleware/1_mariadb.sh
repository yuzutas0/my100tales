#!/bin/bash

su

yum install mariadb mariadb-server

vi /etc/my.conf
# character-set-server=utf8mb4

systemctl start mariadb.service
systemctl enable mariadb.service

mysql_secure_installation
# current password => N/A (only push enter key)
# set password => Y
# new password & confirm password => [new password](Todo: memorialize)
# remove anonymous => Y
# disallow remote root login => Y
# remove test => Y
# reload => Y
