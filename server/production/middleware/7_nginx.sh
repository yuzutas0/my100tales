#!/bin/bash

# ================================
# variables
# ================================

app_name="my100tales"

# ================================
# operation
# ================================

su

yum -y install nginx

systemctl start nginx
systemctl enable nginx

less /etc/nginx/nginx.conf
vim /etc/nginx/conf.d/${app_name}.conf
# => copy from ${rails_root}/server/production/middleware/nginx.conf
