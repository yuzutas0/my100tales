#!/bin/bash

# ================================
# update packages
# ================================

yum -y update

# ================================
# install packages
# ================================

yum -y groupinstall base "Development tools"
yum -y install vim
yum -y install yum-cron

# ================================
# enable to update automatically
# ================================

vim /etc/yum/yum-cron.conf
# from: #apply_updates = yes
# to:   apply_updates = yes

systemctl start yum-cron
systemctl enable yum-cron
