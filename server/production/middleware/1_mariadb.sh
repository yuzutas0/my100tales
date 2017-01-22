#!/bin/bash

# -----------------------
# variables
# -----------------------

db_root_password=$1
app_scheme=$2
db_user=$3
db_user_password=$4
#backup_file=$5

# -----------------------
# install
# -----------------------

su

yum -y install mariadb mariadb-server

cat << _EOF > /etc/my.cnf.d/custom.cnf
[mysqld]
character-set-server=utf8mb4
[client]
default-character-set=utf8mb4
_EOF

systemctl start mariadb
systemctl enable mariadb

systemctl status mariadb
# check: active

mysql_secure_installation
# current password => N/A (only push enter key)
# set password => Y
# new password & confirm password => ${db_root_password}
# remove anonymous => Y
# disallow remote root login => Y
# remove test => Y
# reload => Y

# -----------------------
# scheme & user
# -----------------------

mysql -u root -p
# enter ${db_root_password}

# > create database ${app_scheme};
# > show databases;
# > use ${app_scheme};
# > show variables like "chara%";
#   => check: there's not 'utf8' except for character_set_system.

# > grant all privileges on ${app_scheme}.* to ${db_user}@localhost identified by '${db_user_password}';
# > select Host,User from mysql.user;
# > exit

mysql ${app_scheme} -u ${db_user} -p
# enter ${db_user_password}

# > create table test (example varchar(255), sample text);
# > show create table test;
#   => check: DEFAULT CHARSET=utf8mb4
# > drop table test;
# > exit

# -----------------------
# todo: backup monthly
# -----------------------

# mysqldump --single-transaction -u root -p -x -all-database > ${backup_file}
# enter ${db_root_password}
