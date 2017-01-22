#!/bin/bash

# ================================
# variables
# ================================

app_name=$1
root_url=$2

# ================================
# operation
# ================================

su

yum -y install nginx

systemctl start nginx

systemctl status nginx
# check active

# access by browser at local machine
open ${root_url}

systemctl stop nginx

systemctl status nginx
# check inactive

# TODO: after rails deploy
less /etc/nginx/nginx.conf
vim /etc/nginx/conf.d/${app_name}.conf
# => copy from ${rails_root}/server/production/middleware/nginx.conf

systemctl start nginx
systemctl enable nginx

systemctl status nginx
# check active

systemctl reload nginx
