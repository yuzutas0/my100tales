#!/bin/bash

# ================================
# variables
# ================================

os_user=$1
domain=$2
admin_mail=$3
web_root=/var/www/${domain}/shared/public

# ================================
# install
# ================================

cd /home/${os_user}
git clone https://github.com/certbot/certbot
cd certbot/

su
./certbot-auto

# ================================
# execute
# ================================

# TODO: after deployment

# test
./certbot-auto certonly -m ${admin_mail} --agree-tos --non-interactive $* --webroot -w ${web_root} -d ${domain} --test-cert

# production
./certbot-auto certonly -m ${admin_mail} --agree-tos --non-interactive $* --webroot -w ${web_root} -d ${domain} --force-renewal

# update automatically
cat << _EOF > /etc/cron.weekly/certbot
/home/${os_user}/bin/certbot-auto renew --post-hook "systemctl restart nginx" 1 > /dev/null 2 > /dev/null
_EOF
