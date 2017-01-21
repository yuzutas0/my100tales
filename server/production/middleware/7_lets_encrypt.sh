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
sudo certbot-auto certonly -m ${admin_mail} --agree-tos --non-interactive $* --webroot -w ${web_root} -d ${domain} --test-cert

# production
sudo certbot-auto certonly -m ${admin_mail} --agree-tos --non-interactive $* --webroot -w ${web_root} -d ${domain} --force-renewal

# update automatically
sudo crontab -e
# add: 50 3 * * 0 certbot-auto renew --post-hook "systemctl restart nginx" 1 > /dev/null 2 > /dev/null
