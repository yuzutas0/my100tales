#!/bin/bash

su

yum -y install nginx

systemctl start nginx
systemctl enable nginx

vim /etc/nginx/nginx.conf
