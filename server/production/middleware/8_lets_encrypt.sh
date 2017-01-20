#!/bin/bash

# ================================
# variables
# ================================

domain=$1
web_root=/var/www/${domain}/$2
admin_mail=$3

# ================================
# install
# ================================

git clone https://github.com/certbot/certbot
cd certbot/
sudo ./certbot-auto

# ================================
# execute
# ================================

# test
certbot-auto certonly -m ${admin_mail} --agree-tos --non-interactive $* --webroot -w ${web_root} -d ${domain} --test-cert
# production
certbot-auto certonly -m ${admin_mail} --agree-tos --non-interactive $* --webroot -w ${web_root} -d ${domain} --force-renewal
