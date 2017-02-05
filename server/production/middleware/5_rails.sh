#!/bin/bash

# ================================
# variables
# ================================

app_name=$1
os_user=$2
key_name=$3
ssh_port=$4
server_ip=$5

# ================================
# bundler
# ================================

rbenv exec gem install bundler
rbenv rehash
bundle -v

# ================================
# nmp & bower
# ================================

su
yum install -y nodejs
yum install -y npm
npm install -g bower
exit

bower -v

# ================================
# database connection
# ================================

yum install -y mysql-devel

# ================================
# app
# ================================

sudo mkdir -p /var/www/${app_name}
sudo chown ${os_user} /var/www/${app_name}

exit # from remote server

# ================================
# deployment after nginx settings
# ================================

sed -i "" -e "s/SECRET_KEY_BASE=XXX/SECRET_KEY_BASE=`bundle exec rake secret`/" ./.env
scp -i ~/.ssh/${key_name} -P ${ssh_port} .env ${os_user}@${server_ip}:/var/www/${app_name}/shared/
bundle exec cap production deploy

# ================================
# auto restart when os reboots
# ================================

su

cat << _EOF > /etc/systemd/system/${app_name}_unicorn.service
[Unit]
Description=${app_name} Unicorn Server
After=mariadb.service

[Service]
User=${os_user}
WorkingDirectory=/var/www/${app_name}/current
Environment=RAILS_ENV=production
SyslogIdentifier=${app_name}_unicorn
PIDFile=/var/www/${app_name}/shared/tmp/pids/unicorn.pid

ExecStart=/home/${os_user}/.rbenv/bin/rbenv exec bundle exec "unicorn -c config/unicorn/production.rb -E production"
ExecStop=/usr/bin/kill -QUIT $MAINPID
ExecReload=/bin/kill -USR2 $MAINPID

[Install]
WantedBy=multi-user.target
_EOF

systemctl daemon-reload

systemctl start ${app_name}_unicorn
systemctl enable ${app_name}_unicorn

systemctl status ${app_name}_unicorn
# check active

# ================================
# enable restart without password
# ================================

visudo
# --------------------------------------------------------------------
# after: %wheel        ALL=(ALL)       NOPASSWD: ALL
# add:   ${os_user} ALL=NOPASSWD: /bin/systemctl * ${app_name}_unicorn
# --------------------------------------------------------------------
