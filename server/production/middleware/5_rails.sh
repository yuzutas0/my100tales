#!/bin/bash

# ================================
# variables
# ================================

app_name=my100tales
repository=https://github.com/yuzutas0/my100tales.git

# ================================
# bundler
# ================================

rbenv exec gem install bundler

rbenv rehash

# ================================
# app
# ================================

cd /var/www/

git clone ${repository}

cd ${app_name}

# ================================
# run
# ================================

bundle install --path vendor/bundle

bundle exec unicorn_rails -l 3000 -E production
