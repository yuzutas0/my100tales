#!/bin/bash

# [ruby version] = 2.3.0

ruby -v
sudo yum remove ruby # if ruby has already installed

sudo yum install git
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
sudo ~/.rbenv/plugins/ruby-build/install.sh
rbenv -v

rbenv install [ruby version]
rbenv rehash
rbenv global [ruby version]

ruby -v
which ruby
which gem
