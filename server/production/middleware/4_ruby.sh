#!/bin/bash

# ================================
# variables
# ================================

admin_name=admin
ruby_version=2.3.0
domain=yuzutas0.com

# ================================
# install git
# ================================

ruby -v
sudo yum remove ruby # if ruby has already installed

sudo yum install git
git config --global user.name "${admin_name}"
git config --global user.email "[${admin_name}@${domain}]"

# ================================
# install rbenv
# ================================

git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
source ~/.bash_profile

git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
sudo ~/.rbenv/plugins/ruby-build/install.sh
rbenv -v

# ================================
# install ruby
# ================================

rbenv install ${ruby_version}
rbenv rehash
rbenv global ${ruby_version}

ruby -v
which ruby
which gem
