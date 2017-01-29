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
# deployment after
# ================================

scp -i ~/.ssh/${key_name} -P ${ssh_port} .env ${os_user}@${server_ip}:/var/www/${app_name}/shared/
bundle exec cap production deploy
