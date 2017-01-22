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
# app
# ================================

sudo mkdir -p /var/www/${app_name}
sudo chown ${os_user} /var/www/${app_name}

# TODO: capistrano
git clone ${repository}
cd ${app_name}

# ================================
# run
# ================================

bundle install --path vendor/bundle
bundle exec unicorn_rails -l 3000 -E production
