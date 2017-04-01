#!/bin/bash

# ================================
# variables
# ================================

os_user=$1
domain=$2
admin_mail=$3
app_name=$4
web_root=/var/www/${app_name}/current/public

# ================================
# install
# ================================

cd /home/${os_user}
git clone https://github.com/certbot/certbot
cd certbot/

su
./certbot-auto

# ================================
# execute after deployment
# ================================

# test
./certbot-auto certonly -m ${admin_mail} --agree-tos --non-interactive $* --webroot -w ${web_root} -d ${domain} --test-cert

# production
./certbot-auto certonly -m ${admin_mail} --agree-tos --non-interactive $* --webroot -w ${web_root} -d ${domain} --force-renewal

# update automatically
cat << _EOF > /etc/cron.weekly/certbot
/home/${os_user}/certbot/certbot-auto renew --post-hook "systemctl restart nginx" 1 > /dev/null 2 > /dev/null
_EOF

chmod 755 /etc/cron.weekly/certbot
