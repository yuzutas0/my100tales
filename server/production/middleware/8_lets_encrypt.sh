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
