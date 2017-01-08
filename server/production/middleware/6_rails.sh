#!/bin/bash

# [application name] = my100tales
# [repository] = https://github.com/yuzutas0/my100tales.git

rbenv exec gem install bundler
rbenv rehash

cd /var/www/
git clone [repository]
cd [application name]

bundle install --path vendor/bundle
