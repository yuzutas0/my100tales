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
systemctl enable nginx

systemctl status nginx
# check active

# access by browser at local machine
open ${root_url}
less /etc/nginx/nginx.conf

vim /etc/nginx/conf.d/${app_name}.conf
#  upstream unicorn_server {
#    server unix:/var/www/${app_name}/shared/tmp/sockets/unicorn.sock fail_timeout=0;
#  }
#
#  server {
#    set $app ${app_name};
#    listen 80;
#    listen [::]:80;
#
#    root /var/www/$app/shared/public;
#    access_log /var/log/nginx/access.log main;
#
#    error_page 404 /404.html;
#    error_page 422 /422.html;
#    error_page 400 401 403 404 500 501 502 503 504 /500.html;
#
#    gzip on;
#    gzip_proxied any;
#    gzip_min_length 1k;
#    gzip_types text/html text/css text/javascript application/x-javascript;
#
#    location / {
#      try_files $uri $uri/ http://unicorn_server;
#    }
#  }



systemctl reload nginx

# after settings about lets encrypt

rm /etc/nginx/conf.d/${app_name}.conf
vim /etc/nginx/conf.d/${app_name}.conf
#  upstream unicorn_server {
#    server unix:/var/www/${app_name}/shared/tmp/sockets/unicorn.sock fail_timeout=0;
#  }
#
#  server {
#    listen 80;
#    listen [::]:80;
#    return 301 https://$host$request_uri;
#  }
#
#  server {
#    set $app ${app_name};
#    listen 443 ssl;
#    listen [::]:443 ssl;
#
#    ssl on;
#    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
#    ssl_prefer_server_ciphers on;
#    ssl_ciphers ECDHE+RSAGCM:ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:!EXPORT:!DES:!3DES:!MD5:!DSS;
#
#    ssl_certificate /etc/letsencrypt/live/$host/cert.pem;
#    ssl_certificate_key /etc/letsencrypt/live/$host/privkey.pem;
#
#    root /var/www/$app/shared/public;
#    access_log /var/log/nginx/access.log main;
#
#    error_page 404 /404.html;
#    error_page 422 /422.html;
#    error_page 400 401 403 404 500 501 502 503 504 /500.html;
#
#    gzip on;
#    gzip_proxied any;
#    gzip_min_length 1k;
#    gzip_types text/html text/css text/javascript application/x-javascript;
#
#    location / {
#      try_files $uri $uri/ http://unicorn_server;
#    }
#  }

systemctl reload nginx
