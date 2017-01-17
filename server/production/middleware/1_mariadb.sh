#!/bin/bash

# -----------------------
# variables
# -----------------------

root_password=$1
db_user=$2
db_user_password=$3
scheme=$4
#backup_file=$5

# -----------------------
# install
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
# new password & confirm password => ${root_password}
# remove anonymous => Y
# disallow remote root login => Y
# remove test => Y
# reload => Y

mysql -u root -p
# enter ${root_password}

# create user ${db_user};
# set password for ${db_user} = password('${db_user_password}');
# create database ${schema};
# grant all on ${schema}.* to ${db_user};

# show databases
# select User from mysql.user;
# exit

mysql -u ${db_user} -p
# enter ${db_user_password}

# show databases;
# use ${schema};
# show variables like "chara%";
#   => make sure there's not 'utf8'.
# exit

# todo: backup monthly
# mysqldump --single-transaction -u root -p -x -all-database > ${backup_file}
# enter ${root_password}
