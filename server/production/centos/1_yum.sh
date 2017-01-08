#!/bin/bash

# ================================
# update packages
# ================================

yum -y update

# ================================
# enable to update automatically
# ================================

yum -y install yum-cron

vi /etc/yum/yum-cron.conf
# => apply_updates = yes

systemctl start yum-cron

systemctl enable yum-cron

yum -y groupinstall base "Development tools"
yum install vim
