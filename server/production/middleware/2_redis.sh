#!/bin/bash

wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

su

yum install epel-release
rpm -Uvh remi-release-7*.rpm
yum --enablerepo=remi,remi-test,epel install redis

systemctl start redis.service
systemctl enable redis.service
