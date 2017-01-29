#!/bin/bash

# ================================
# variables
# ================================

app_name=$1
os_user=$2
app_repository=$3

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

bundle exec cap production deploy
