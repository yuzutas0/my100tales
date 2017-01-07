#!/bin/bash

# -----------------------
# variables
# -----------------------
# [root password]
# [user]
# [user password]
# [scheme]
# [backup file]
# -----------------------

su

yum install mariadb mariadb-server

vi /etc/my.conf
# [mysqld]
# character-set-server=utf8mb4
# [client]
# default-character-set=utf8mb4

systemctl start mariadb.service
systemctl enable mariadb.service

mysql_secure_installation
# current password => N/A (only push enter key)
# set password => Y
# new password & confirm password => [root password]
# remove anonymous => Y
# disallow remote root login => Y
# remove test => Y
# reload => Y

mysql -u root -p
# enter [root password]

# create user [user];
# set password for [user] = password('[user password]');
# create database [schema];
# grant all on [schema].* to [user];

# show databases
# select User from mysql.user;
# exit

mysql -u [user] -p
# enter [user password]

# show databases;
# use [scheme];
# show variables like "chara%";
#   => make sure there's not 'utf8'.
# exit

# todo: backup monthly
# mysqldump --single-transaction -u root -p -x -all-database > [backup file]
# enter [root password]
