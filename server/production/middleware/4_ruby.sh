#!/bin/bash

# ================================
# variables
# ================================

git_user_name=$1
domain_name=$2
ruby_version=$3

# ================================
# prepare
# ================================

exit # if you used 'su' command at previous operation

ruby -v
sudo yum remove ruby # if ruby has already installed

# ================================
# install git
# ================================

sudo yum -y install git
git config --global user.name "${git_user_name}"
git config --global user.email "[${git_user_name}@${domain_name}]"

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

sudo yum install -y openssl-devel readline-devel zlib-devel

rbenv install ${ruby_version}
rbenv rehash
rbenv global ${ruby_version}

ruby -v
which ruby
which gem
