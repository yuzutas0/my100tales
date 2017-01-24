#!/bin/bash

# TODO
su

yum install -y rsync

# DB, log, ...
cat << _EOF > /etc/rsync_exclude.lst
+ /home/***
+ /var/www/***
_EOF
